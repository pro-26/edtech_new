/*
  This is the subjects view for the user.
  It displays the list of subjects and allows the user to search for a subject.
  It also provides options to filter the subjects by category and instructor.

  created by : Farseen
  date : 2025-08-13
  upated by : Muhammed Shabeer OP
  last updated : 2025-11-27
*/

import 'package:ed_tech/app/data/models/subject.model.dart';
import 'package:ed_tech/app/modules/home/controllers/subjects.controller.dart';
import 'package:ed_tech/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../global_widgets/subject_card_horizontal.dart';
import '../../../global_widgets/custom_search_bar.dart';

class SubjectsView extends GetResponsiveView<SubjectsController> {
  SubjectsView({super.key});

  @override
  Widget phone() {
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            title: Text('Subjects'),
            centerTitle: true,
            backgroundColor: Get.theme.colorScheme.primary,
            foregroundColor: Get.theme.colorScheme.onPrimary,
            pinned: true,
            expandedHeight: Get.height * 0.20,
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFilterTabs(),
                  SizedBox(height: 10),
                  _buildCustomSearchBar(),
                ],
              ).paddingAll(16),
            ),
          ),

          // Subjects list as a sliver
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            sliver: Obx(() {
              if (controller.isLoading.value) {
                return SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (controller.displayedCourses.isEmpty) {
                return SliverToBoxAdapter(
                  child: Center(child: Text("No courses found")),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final course = controller.displayedCourses[index];
                  return SubjectsCard(
                    course: course,
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
                  );
                }, childCount: controller.displayedCourses.length),
              );
            }),
          ),

          // Bottom spacing
          SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    final filterTabs = ['All', 'My Subjects', 'Completed'];

    return Obx(
      () => Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: filterTabs.map((tab) {
          return _buildFilterChip(tab, tab == controller.selectedFilter.value);
        }).toList(),
      ),
    );
  }

  Widget _buildFilterChip(String title, bool isSelected) {
    return ChoiceChip(
      label: Text(title),
      checkmarkColor: Get.theme.colorScheme.onPrimaryContainer,
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          controller.filterCourses(title);
        }
      },
      selectedColor: Get.theme.colorScheme.onPrimary,
      labelStyle: TextStyle(
        color: Get.theme.colorScheme.onPrimaryContainer,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: isSelected
          ? Get.theme.colorScheme.primary
          : Get.theme.colorScheme.primaryContainer,
      shape: StadiumBorder(
        side: BorderSide(
          color: isSelected
              ? Get.theme.colorScheme.primary
              : Colors.transparent,
          width: 1,
        ),
      ),
    );
  }

  Widget _buildCustomSearchBar() {
    return CustomSearchBar(
      hintText: 'Search subject...',
      backgroundColor: Get.theme.colorScheme.surface,
      hintColor: Get.theme.colorScheme.onSurface,
      prefixIcon: Icon(Icons.search, color: Get.theme.colorScheme.onSurface),
      outlined: true,
      cursorAndTextColor: Get.theme.colorScheme.onSurface,
    );
  }
}
