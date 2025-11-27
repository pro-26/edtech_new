/*
  DashboardView
  - Purpose: Main user dashboard. Shows enrolled courses, continue-learning area,
    and a sliver app bar with user quick actions.
  - Notes: Responsive via GetResponsiveView. Uses small helper widgets and cached
    images. This is a non-functional header to aid future readers.
  - Author: Muhammed Shabeer OP
  - Added: 2025-11-27 (annotation)
*/

import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

import 'package:ed_tech/app/data/models/subject.model.dart';
import 'package:ed_tech/app/global_widgets/continue_learning_card.dart';
import 'package:ed_tech/app/global_widgets/custom_app_bar.dart';
import 'package:ed_tech/app/global_widgets/custom_search_bar.dart';
import 'package:ed_tech/app/global_widgets/subject_card.dart';
import 'package:ed_tech/app/modules/home/controllers/dashboard.controller.dart';
import 'package:ed_tech/app/routes/app_pages.dart';

class DashboardView extends GetResponsiveView<DashboardController> {
  DashboardView({super.key}) : super(alwaysUseBuilder: false);

  @override
  Widget? phone() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(Get.context!).unfocus(); // Dismiss keyboard on tap
      },
      child: Scaffold(
        primary: true,
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return CustomScrollView(
            slivers: [
              _buildSliverAppBar(),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (controller.enrolledCourses.isNotEmpty) ...[
                      _buildEnrolledCoursesHeader(),
                      _buildEnrolledCoursesList(),
                    ],
                    if (controller.enrolledCourses.isNotEmpty) ...[
                      _buildContinueLearningHeader(),
                      _buildContinueLearningCard(),
                    ],
                    // If no enrolled courses, maybe show featured courses?
                    if (controller.enrolledCourses.isEmpty &&
                        controller.featuredCourses.isNotEmpty) ...[
                      _buildFeaturedCoursesHeader(),
                      _buildFeaturedCoursesList(),
                    ],
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildEnrolledCoursesHeader() {
    return Row(
      children: [
        Text(
          "Enrolled Courses",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Get.theme.colorScheme.onSurface,
          ),
        ),
        const Spacer(),
        TextButton(onPressed: () {}, child: const Text("See All")),
      ],
    ).paddingSymmetric(horizontal: 16, vertical: 8);
  }

  Widget _buildEnrolledCoursesList() {
    return SizedBox(
      height: 250,
      child: ListView.separated(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        scrollDirection: Axis.horizontal,
        itemCount: controller.enrolledCourses.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final course = controller.enrolledCourses[index];
          return SubjectCardVertical(
            title: course.title,
            instructor: 'Instructor', // We might need to fetch instructor name
            imageUrl:
                course.thumbnail ??
                'https://images.unsplash.com/photo-1551434678-e076c223a692?w=800',
            onTap: () {
              // Navigate to course details
              Get.toNamed(
                Routes.COURSE_DETAILS,
                arguments: {
                  'courseId':
                      course.id, // Pass ID instead of full object if preferred
                  'subject': SubjectModel(
                    subjectId: 0, // Dummy ID
                    title: course.title,
                    imageUrl: course.thumbnail ?? '',
                  ),
                },
              );
            },
            width: 200,
          );
        },
      ),
    );
  }

  Widget _buildContinueLearningHeader() {
    return Row(
      children: [
        Text(
          "Continue Learning",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Get.theme.colorScheme.onSurface,
          ),
        ),
        const Spacer(),
        TextButton(onPressed: () {}, child: const Text("See All")),
      ],
    ).paddingOnly(left: 16, right: 16, bottom: 8);
  }

  Widget _buildContinueLearningCard() {
    // Just show the first enrolled course as "Continue Learning" for now
    final course = controller.enrolledCourses.first;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ContinueLearningCard(
        lessonLabel: 'Lesson 1', // Placeholder
        title: course.title,
        subtitle: course.description,
        imageUrl:
            course.thumbnail ??
            'https://images.unsplash.com/photo-1551434678-e076c223a692?w=800',
        progress: 0.10, // Placeholder
        onContinue: () {},
      ),
    );
  }

  Widget _buildFeaturedCoursesHeader() {
    return Row(
      children: [
        Text(
          "Featured Courses",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Get.theme.colorScheme.onSurface,
          ),
        ),
        const Spacer(),
        TextButton(onPressed: () {}, child: const Text("See All")),
      ],
    ).paddingSymmetric(horizontal: 16, vertical: 8);
  }

  Widget _buildFeaturedCoursesList() {
    return SizedBox(
      height: 250,
      child: ListView.separated(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        scrollDirection: Axis.horizontal,
        itemCount: controller.featuredCourses.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final course = controller.featuredCourses[index];
          return SubjectCardVertical(
            title: course.title,
            instructor: course.instructorName ?? 'Instructor',
            imageUrl:
                course.thumbnail ??
                'https://images.unsplash.com/photo-1551434678-e076c223a692?w=800',
            onTap: () {
              Get.toNamed(
                Routes.COURSE_DETAILS,
                arguments: {
                  'courseId': course.id,
                  'subject': SubjectModel(
                    subjectId: 0,
                    title: course.title,
                    imageUrl: course.thumbnail ?? '',
                  ),
                },
              );
            },
            width: 200,
          );
        },
      ),
    );
  }

  @override
  Widget? tablet() {
    return phone(); // simple reuse for now
  }

  @override
  Widget? desktop() {
    return phone(); // simple reuse for now
  }

  SliverAppBar _buildSliverAppBar() {
    Chip userDChip(IconData icon, String value) => Chip(
      labelPadding: EdgeInsets.zero,
      avatar: Icon(icon, color: Get.theme.colorScheme.primary, size: 16),
      label: Text(
        value,
        style: TextStyle(
          color: Get.theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: Colors.transparent,
      shape: StadiumBorder(
        side: BorderSide(color: Get.theme.colorScheme.onPrimary),
      ),
    );

    final expandedHeight =
        (Get.height * 0.10) + 48 + 20 + 50 + 60; // matches previous layout

    return SliverAppBar(
      pinned: true,
      expandedHeight: expandedHeight,
      backgroundColor: Get.theme.colorScheme.primary,
      elevation: 0,
      centerTitle: false,
      collapsedHeight: kToolbarHeight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(50)),
      ),
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          return FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            background: CustomTopBar(
              // disable its internal safe area so we can manage it here
              safeArea: false,
              child: SafeArea(
                bottom: false,
                child: Container(
                  margin: EdgeInsets.only(
                    top: Get.height * 0.02,
                    bottom: Get.height * 0.02,
                    left: Get.width * 0.05,
                    right: Get.width * 0.05,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.menu,
                              color: Get.theme.colorScheme.onPrimary,
                            ),
                            onPressed: () {},
                          ),
                          const Spacer(),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: Get.theme.colorScheme.onPrimary,
                              ),
                            ),
                            onPressed: () => Get.toNamed(Routes.NOTIFICATION),
                            icon: Badge.count(
                              smallSize: 10,
                              isLabelVisible: true,
                              offset: const Offset(5, -5),
                              count: 3,
                              child: Icon(
                                Icons.notifications,
                                color: Get.theme.colorScheme.onPrimary,
                              ),
                            ),
                            label: Text(
                              'Notifications',
                              style: TextStyle(
                                color: Get.theme.colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: Get.width * 0.02),
                          CircleAvatar(
                            radius: 30,
                            // changed to cached network image
                            backgroundImage: CachedNetworkImageProvider(
                              controller.currentUser.value?.profilePicture ??
                                  'https://avatar.iran.liara.run/public/40',
                            ),
                            backgroundColor: Get.theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: Get.width * 0.6,
                                child: Text(
                                  'Hello, ${controller.currentUser.value?.name ?? 'User'}',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Get.theme.colorScheme.onPrimary,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              IntrinsicWidth(
                                stepWidth: 100,
                                child: Row(
                                  children: [
                                    userDChip(Icons.star_outline, '100'),
                                    const SizedBox(width: 10),
                                    userDChip(Icons.monetization_on, '50'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const CustomSearchBar(
                        hintText: "Search course...",
                        readOnly: false,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
