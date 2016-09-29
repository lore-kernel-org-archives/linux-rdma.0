From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 rdma-core 3/5] ccan: Add list functionality
Date: Thu, 29 Sep 2016 14:11:00 +0300
Message-ID: <1475147462-803-4-git-send-email-yishaih@mellanox.com>
References: <1475147462-803-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475147462-803-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add CCAN list functionality to be used by down stream
patches.

It includes changes to relevant cmake files among the project
as introduced by Jason.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 buildlib/rdma_functions.cmake        |   8 +
 ccan/CMakeLists.txt                  |  12 +
 ccan/check_type.h                    |  64 +++
 ccan/container_of.h                  | 146 ++++++
 ccan/list.h                          | 842 +++++++++++++++++++++++++++++++++++
 ccan/str.c                           |  13 +
 ccan/str.h                           | 228 ++++++++++
 ccan/str_debug.h                     |  30 ++
 ibacm/CMakeLists.txt                 |   6 +-
 iwpmd/src/CMakeLists.txt             |   2 +-
 libibcm/examples/CMakeLists.txt      |   2 +-
 libibumad/tests/CMakeLists.txt       |   4 +-
 libibverbs/examples/CMakeLists.txt   |  16 +-
 librdmacm/examples/CMakeLists.txt    |  26 +-
 srp_daemon/srp_daemon/CMakeLists.txt |   2 +-
 15 files changed, 1372 insertions(+), 29 deletions(-)
 create mode 100644 ccan/check_type.h
 create mode 100644 ccan/container_of.h
 create mode 100644 ccan/list.h
 create mode 100644 ccan/str.c
 create mode 100644 ccan/str.h
 create mode 100644 ccan/str_debug.h

diff --git a/buildlib/rdma_functions.cmake b/buildlib/rdma_functions.cmake
index ea53f38..5a1041f 100644
--- a/buildlib/rdma_functions.cmake
+++ b/buildlib/rdma_functions.cmake
@@ -6,6 +6,9 @@
 # Global list of pairs of (SHARED STATIC) libary target names
 set(RDMA_STATIC_LIBS "" CACHE INTERNAL "Doc" FORCE)
 
+set(COMMON_LIBS_PIC ccan_pic)
+set(COMMON_LIBS ccan)
+
 # Install a symlink during 'make install'
 function(rdma_install_symlink LINK_CONTENT DEST)
   # Create a link in the build tree with the right content
@@ -59,6 +62,7 @@ function(rdma_library DEST VERSION_SCRIPT SOVERSION VERSION)
   # Create a shared library
   add_library(${DEST} SHARED ${ARGN})
   rdma_set_library_map(${DEST} ${VERSION_SCRIPT})
+  target_link_libraries(${DEST} LINK_PRIVATE ${COMMON_LIBS_PIC})
   set_target_properties(${DEST} PROPERTIES
     SOVERSION ${SOVERSION}
     VERSION ${VERSION}
@@ -98,6 +102,7 @@ function(rdma_provider DEST)
   # Even though these are modules we still want to use Wl,--no-undefined
   set_target_properties(${DEST} PROPERTIES LINK_FLAGS ${CMAKE_SHARED_LINKER_FLAGS})
   rdma_set_library_map(${DEST} ${BUILDLIB}/provider.map)
+  target_link_libraries(${DEST} LINK_PRIVATE ${COMMON_LIBS_PIC})
   target_link_libraries(${DEST} LINK_PRIVATE ibverbs)
   target_link_libraries(${DEST} LINK_PRIVATE ${CMAKE_THREAD_LIBS_INIT})
   set_target_properties(${DEST} PROPERTIES LIBRARY_OUTPUT_DIRECTORY "${BUILD_LIB}")
@@ -110,6 +115,7 @@ endfunction()
  # Create an installed executable
 function(rdma_executable EXEC)
   add_executable(${EXEC} ${ARGN})
+  target_link_libraries(${EXEC} LINK_PRIVATE ${COMMON_LIBS})
   set_target_properties(${EXEC} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${BUILD_BIN}")
   install(TARGETS ${EXEC} DESTINATION "${CMAKE_INSTALL_BINDIR}")
 endfunction()
@@ -117,6 +123,7 @@ endfunction()
  # Create an installed executable (under sbin)
 function(rdma_sbin_executable EXEC)
   add_executable(${EXEC} ${ARGN})
+  target_link_libraries(${EXEC} LINK_PRIVATE ${COMMON_LIBS})
   set_target_properties(${EXEC} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${BUILD_BIN}")
   install(TARGETS ${EXEC} DESTINATION "${CMAKE_INSTALL_SBINDIR}")
 endfunction()
@@ -124,6 +131,7 @@ endfunction()
 # Create an test executable (not-installed)
 function(rdma_test_executable EXEC)
   add_executable(${EXEC} ${ARGN})
+  target_link_libraries(${EXEC} LINK_PRIVATE ${COMMON_LIBS})
   set_target_properties(${EXEC} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${BUILD_BIN}")
 endfunction()
 
diff --git a/ccan/CMakeLists.txt b/ccan/CMakeLists.txt
index dc74d80..505e026 100644
--- a/ccan/CMakeLists.txt
+++ b/ccan/CMakeLists.txt
@@ -1,4 +1,16 @@
 publish_internal_headers(ccan
   build_assert.h
+  check_type.h
+  container_of.h
+  list.h
   minmax.h
+  str.h
+  str_debug.h
   )
+
+set(C_FILES
+  str.c
+  )
+add_library(ccan STATIC ${C_FILES})
+add_library(ccan_pic STATIC ${C_FILES})
+set_property(TARGET ccan_pic PROPERTY POSITION_INDEPENDENT_CODE TRUE)
diff --git a/ccan/check_type.h b/ccan/check_type.h
new file mode 100644
index 0000000..77501a9
--- /dev/null
+++ b/ccan/check_type.h
@@ -0,0 +1,64 @@
+/* CC0 (Public domain) - see LICENSE file for details */
+#ifndef CCAN_CHECK_TYPE_H
+#define CCAN_CHECK_TYPE_H
+#include "config.h"
+
+/**
+ * check_type - issue a warning or build failure if type is not correct.
+ * @expr: the expression whose type we should check (not evaluated).
+ * @type: the exact type we expect the expression to be.
+ *
+ * This macro is usually used within other macros to try to ensure that a macro
+ * argument is of the expected type.  No type promotion of the expression is
+ * done: an unsigned int is not the same as an int!
+ *
+ * check_type() always evaluates to 0.
+ *
+ * If your compiler does not support typeof, then the best we can do is fail
+ * to compile if the sizes of the types are unequal (a less complete check).
+ *
+ * Example:
+ *	// They should always pass a 64-bit value to _set_some_value!
+ *	#define set_some_value(expr)			\
+ *		_set_some_value((check_type((expr), uint64_t), (expr)))
+ */
+
+/**
+ * check_types_match - issue a warning or build failure if types are not same.
+ * @expr1: the first expression (not evaluated).
+ * @expr2: the second expression (not evaluated).
+ *
+ * This macro is usually used within other macros to try to ensure that
+ * arguments are of identical types.  No type promotion of the expressions is
+ * done: an unsigned int is not the same as an int!
+ *
+ * check_types_match() always evaluates to 0.
+ *
+ * If your compiler does not support typeof, then the best we can do is fail
+ * to compile if the sizes of the types are unequal (a less complete check).
+ *
+ * Example:
+ *	// Do subtraction to get to enclosing type, but make sure that
+ *	// pointer is of correct type for that member.
+ *	#define container_of(mbr_ptr, encl_type, mbr)			\
+ *		(check_types_match((mbr_ptr), &((encl_type *)0)->mbr),	\
+ *		 ((encl_type *)						\
+ *		  ((char *)(mbr_ptr) - offsetof(enclosing_type, mbr))))
+ */
+#if HAVE_TYPEOF
+#define check_type(expr, type)			\
+	((typeof(expr) *)0 != (type *)0)
+
+#define check_types_match(expr1, expr2)		\
+	((typeof(expr1) *)0 != (typeof(expr2) *)0)
+#else
+#include <ccan/build_assert/build_assert.h>
+/* Without typeof, we can only test the sizes. */
+#define check_type(expr, type)					\
+	BUILD_ASSERT_OR_ZERO(sizeof(expr) == sizeof(type))
+
+#define check_types_match(expr1, expr2)				\
+	BUILD_ASSERT_OR_ZERO(sizeof(expr1) == sizeof(expr2))
+#endif /* HAVE_TYPEOF */
+
+#endif /* CCAN_CHECK_TYPE_H */
diff --git a/ccan/container_of.h b/ccan/container_of.h
new file mode 100644
index 0000000..c91b909
--- /dev/null
+++ b/ccan/container_of.h
@@ -0,0 +1,146 @@
+/* CC0 (Public domain) - see LICENSE file for details */
+#ifndef CCAN_CONTAINER_OF_H
+#define CCAN_CONTAINER_OF_H
+#include <stddef.h>
+
+#include "config.h"
+#include <ccan/check_type.h>
+
+/**
+ * container_of - get pointer to enclosing structure
+ * @member_ptr: pointer to the structure member
+ * @containing_type: the type this member is within
+ * @member: the name of this member within the structure.
+ *
+ * Given a pointer to a member of a structure, this macro does pointer
+ * subtraction to return the pointer to the enclosing type.
+ *
+ * Example:
+ *	struct foo {
+ *		int fielda, fieldb;
+ *		// ...
+ *	};
+ *	struct info {
+ *		int some_other_field;
+ *		struct foo my_foo;
+ *	};
+ *
+ *	static struct info *foo_to_info(struct foo *foo)
+ *	{
+ *		return container_of(foo, struct info, my_foo);
+ *	}
+ */
+#ifndef container_of
+#define container_of(member_ptr, containing_type, member)		\
+	 ((containing_type *)						\
+	  ((char *)(member_ptr)						\
+	   - container_off(containing_type, member))			\
+	  + check_types_match(*(member_ptr), ((containing_type *)0)->member))
+#endif
+
+/**
+ * container_of_or_null - get pointer to enclosing structure, or NULL
+ * @member_ptr: pointer to the structure member
+ * @containing_type: the type this member is within
+ * @member: the name of this member within the structure.
+ *
+ * Given a pointer to a member of a structure, this macro does pointer
+ * subtraction to return the pointer to the enclosing type, unless it
+ * is given NULL, in which case it also returns NULL.
+ *
+ * Example:
+ *	struct foo {
+ *		int fielda, fieldb;
+ *		// ...
+ *	};
+ *	struct info {
+ *		int some_other_field;
+ *		struct foo my_foo;
+ *	};
+ *
+ *	static struct info *foo_to_info_allowing_null(struct foo *foo)
+ *	{
+ *		return container_of_or_null(foo, struct info, my_foo);
+ *	}
+ */
+static inline char *container_of_or_null_(void *member_ptr, size_t offset)
+{
+	return member_ptr ? (char *)member_ptr - offset : NULL;
+}
+#define container_of_or_null(member_ptr, containing_type, member)	\
+	((containing_type *)						\
+	 container_of_or_null_(member_ptr,				\
+			       container_off(containing_type, member))	\
+	 + check_types_match(*(member_ptr), ((containing_type *)0)->member))
+
+/**
+ * container_off - get offset to enclosing structure
+ * @containing_type: the type this member is within
+ * @member: the name of this member within the structure.
+ *
+ * Given a pointer to a member of a structure, this macro does
+ * typechecking and figures out the offset to the enclosing type.
+ *
+ * Example:
+ *	struct foo {
+ *		int fielda, fieldb;
+ *		// ...
+ *	};
+ *	struct info {
+ *		int some_other_field;
+ *		struct foo my_foo;
+ *	};
+ *
+ *	static struct info *foo_to_info(struct foo *foo)
+ *	{
+ *		size_t off = container_off(struct info, my_foo);
+ *		return (void *)((char *)foo - off);
+ *	}
+ */
+#define container_off(containing_type, member)	\
+	offsetof(containing_type, member)
+
+/**
+ * container_of_var - get pointer to enclosing structure using a variable
+ * @member_ptr: pointer to the structure member
+ * @container_var: a pointer of same type as this member's container
+ * @member: the name of this member within the structure.
+ *
+ * Given a pointer to a member of a structure, this macro does pointer
+ * subtraction to return the pointer to the enclosing type.
+ *
+ * Example:
+ *	static struct info *foo_to_i(struct foo *foo)
+ *	{
+ *		struct info *i = container_of_var(foo, i, my_foo);
+ *		return i;
+ *	}
+ */
+#if HAVE_TYPEOF
+#define container_of_var(member_ptr, container_var, member) \
+	container_of(member_ptr, typeof(*container_var), member)
+#else
+#define container_of_var(member_ptr, container_var, member)	\
+	((void *)((char *)(member_ptr)	-			\
+		  container_off_var(container_var, member)))
+#endif
+
+/**
+ * container_off_var - get offset of a field in enclosing structure
+ * @container_var: a pointer to a container structure
+ * @member: the name of a member within the structure.
+ *
+ * Given (any) pointer to a structure and a its member name, this
+ * macro does pointer subtraction to return offset of member in a
+ * structure memory layout.
+ *
+ */
+#if HAVE_TYPEOF
+#define container_off_var(var, member)		\
+	container_off(typeof(*var), member)
+#else
+#define container_off_var(var, member)			\
+	((const char *)&(var)->member - (const char *)(var))
+#endif
+
+#endif /* CCAN_CONTAINER_OF_H */
diff --git a/ccan/list.h b/ccan/list.h
new file mode 100644
index 0000000..5bc93ff
--- /dev/null
+++ b/ccan/list.h
@@ -0,0 +1,842 @@
+/* Licensed under BSD-MIT - see LICENSE file for details */
+#ifndef CCAN_LIST_H
+#define CCAN_LIST_H
+//#define CCAN_LIST_DEBUG 1
+#include <stdbool.h>
+#include <assert.h>
+#include <ccan/str.h>
+#include <ccan/container_of.h>
+#include <ccan/check_type.h>
+
+/**
+ * struct list_node - an entry in a doubly-linked list
+ * @next: next entry (self if empty)
+ * @prev: previous entry (self if empty)
+ *
+ * This is used as an entry in a linked list.
+ * Example:
+ *	struct child {
+ *		const char *name;
+ *		// Linked list of all us children.
+ *		struct list_node list;
+ *	};
+ */
+struct list_node
+{
+	struct list_node *next, *prev;
+};
+
+/**
+ * struct list_head - the head of a doubly-linked list
+ * @h: the list_head (containing next and prev pointers)
+ *
+ * This is used as the head of a linked list.
+ * Example:
+ *	struct parent {
+ *		const char *name;
+ *		struct list_head children;
+ *		unsigned int num_children;
+ *	};
+ */
+struct list_head
+{
+	struct list_node n;
+};
+
+/**
+ * list_check - check head of a list for consistency
+ * @h: the list_head
+ * @abortstr: the location to print on aborting, or NULL.
+ *
+ * Because list_nodes have redundant information, consistency checking between
+ * the back and forward links can be done.  This is useful as a debugging check.
+ * If @abortstr is non-NULL, that will be printed in a diagnostic if the list
+ * is inconsistent, and the function will abort.
+ *
+ * Returns the list head if the list is consistent, NULL if not (it
+ * can never return NULL if @abortstr is set).
+ *
+ * See also: list_check_node()
+ *
+ * Example:
+ *	static void dump_parent(struct parent *p)
+ *	{
+ *		struct child *c;
+ *
+ *		printf("%s (%u children):\n", p->name, p->num_children);
+ *		list_check(&p->children, "bad child list");
+ *		list_for_each(&p->children, c, list)
+ *			printf(" -> %s\n", c->name);
+ *	}
+ */
+struct list_head *list_check(const struct list_head *h, const char *abortstr);
+
+/**
+ * list_check_node - check node of a list for consistency
+ * @n: the list_node
+ * @abortstr: the location to print on aborting, or NULL.
+ *
+ * Check consistency of the list node is in (it must be in one).
+ *
+ * See also: list_check()
+ *
+ * Example:
+ *	static void dump_child(const struct child *c)
+ *	{
+ *		list_check_node(&c->list, "bad child list");
+ *		printf("%s\n", c->name);
+ *	}
+ */
+struct list_node *list_check_node(const struct list_node *n,
+				  const char *abortstr);
+
+#define LIST_LOC __FILE__  ":" stringify(__LINE__)
+#ifdef CCAN_LIST_DEBUG
+#define list_debug(h, loc) list_check((h), loc)
+#define list_debug_node(n, loc) list_check_node((n), loc)
+#else
+#define list_debug(h, loc) ((void)loc, h)
+#define list_debug_node(n, loc) ((void)loc, n)
+#endif
+
+/**
+ * LIST_HEAD_INIT - initializer for an empty list_head
+ * @name: the name of the list.
+ *
+ * Explicit initializer for an empty list.
+ *
+ * See also:
+ *	LIST_HEAD, list_head_init()
+ *
+ * Example:
+ *	static struct list_head my_list = LIST_HEAD_INIT(my_list);
+ */
+#define LIST_HEAD_INIT(name) { { &(name).n, &(name).n } }
+
+/**
+ * LIST_HEAD - define and initialize an empty list_head
+ * @name: the name of the list.
+ *
+ * The LIST_HEAD macro defines a list_head and initializes it to an empty
+ * list.  It can be prepended by "static" to define a static list_head.
+ *
+ * See also:
+ *	LIST_HEAD_INIT, list_head_init()
+ *
+ * Example:
+ *	static LIST_HEAD(my_global_list);
+ */
+#define LIST_HEAD(name) \
+	struct list_head name = LIST_HEAD_INIT(name)
+
+/**
+ * list_head_init - initialize a list_head
+ * @h: the list_head to set to the empty list
+ *
+ * Example:
+ *	...
+ *	struct parent *parent = malloc(sizeof(*parent));
+ *
+ *	list_head_init(&parent->children);
+ *	parent->num_children = 0;
+ */
+static inline void list_head_init(struct list_head *h)
+{
+	h->n.next = h->n.prev = &h->n;
+}
+
+/**
+ * list_node_init - initialize a list_node
+ * @n: the list_node to link to itself.
+ *
+ * You don't need to use this normally!  But it lets you list_del(@n)
+ * safely.
+ */
+static inline void list_node_init(struct list_node *n)
+{
+	n->next = n->prev = n;
+}
+
+/**
+ * list_add_after - add an entry after an existing node in a linked list
+ * @h: the list_head to add the node to (for debugging)
+ * @p: the existing list_node to add the node after
+ * @n: the new list_node to add to the list.
+ *
+ * The existing list_node must already be a member of the list.
+ * The new list_node does not need to be initialized; it will be overwritten.
+ *
+ * Example:
+ *	struct child c1, c2, c3;
+ *	LIST_HEAD(h);
+ *
+ *	list_add_tail(&h, &c1.list);
+ *	list_add_tail(&h, &c3.list);
+ *	list_add_after(&h, &c1.list, &c2.list);
+ */
+#define list_add_after(h, p, n) list_add_after_(h, p, n, LIST_LOC)
+static inline void list_add_after_(struct list_head *h,
+				   struct list_node *p,
+				   struct list_node *n,
+				   const char *abortstr)
+{
+	n->next = p->next;
+	n->prev = p;
+	p->next->prev = n;
+	p->next = n;
+	(void)list_debug(h, abortstr);
+}
+
+/**
+ * list_add - add an entry at the start of a linked list.
+ * @h: the list_head to add the node to
+ * @n: the list_node to add to the list.
+ *
+ * The list_node does not need to be initialized; it will be overwritten.
+ * Example:
+ *	struct child *child = malloc(sizeof(*child));
+ *
+ *	child->name = "marvin";
+ *	list_add(&parent->children, &child->list);
+ *	parent->num_children++;
+ */
+#define list_add(h, n) list_add_(h, n, LIST_LOC)
+static inline void list_add_(struct list_head *h,
+			     struct list_node *n,
+			     const char *abortstr)
+{
+	list_add_after_(h, &h->n, n, abortstr);
+}
+
+/**
+ * list_add_before - add an entry before an existing node in a linked list
+ * @h: the list_head to add the node to (for debugging)
+ * @p: the existing list_node to add the node before
+ * @n: the new list_node to add to the list.
+ *
+ * The existing list_node must already be a member of the list.
+ * The new list_node does not need to be initialized; it will be overwritten.
+ *
+ * Example:
+ *	list_head_init(&h);
+ *	list_add_tail(&h, &c1.list);
+ *	list_add_tail(&h, &c3.list);
+ *	list_add_before(&h, &c3.list, &c2.list);
+ */
+#define list_add_before(h, p, n) list_add_before_(h, p, n, LIST_LOC)
+static inline void list_add_before_(struct list_head *h,
+				    struct list_node *p,
+				    struct list_node *n,
+				    const char *abortstr)
+{
+	n->next = p;
+	n->prev = p->prev;
+	p->prev->next = n;
+	p->prev = n;
+	(void)list_debug(h, abortstr);
+}
+
+/**
+ * list_add_tail - add an entry at the end of a linked list.
+ * @h: the list_head to add the node to
+ * @n: the list_node to add to the list.
+ *
+ * The list_node does not need to be initialized; it will be overwritten.
+ * Example:
+ *	list_add_tail(&parent->children, &child->list);
+ *	parent->num_children++;
+ */
+#define list_add_tail(h, n) list_add_tail_(h, n, LIST_LOC)
+static inline void list_add_tail_(struct list_head *h,
+				  struct list_node *n,
+				  const char *abortstr)
+{
+	list_add_before_(h, &h->n, n, abortstr);
+}
+
+/**
+ * list_empty - is a list empty?
+ * @h: the list_head
+ *
+ * If the list is empty, returns true.
+ *
+ * Example:
+ *	assert(list_empty(&parent->children) == (parent->num_children == 0));
+ */
+#define list_empty(h) list_empty_(h, LIST_LOC)
+static inline bool list_empty_(const struct list_head *h, const char* abortstr)
+{
+	(void)list_debug(h, abortstr);
+	return h->n.next == &h->n;
+}
+
+/**
+ * list_empty_nodebug - is a list empty (and don't perform debug checks)?
+ * @h: the list_head
+ *
+ * If the list is empty, returns true.
+ * This differs from list_empty() in that if CCAN_LIST_DEBUG is set it
+ * will NOT perform debug checks. Only use this function if you REALLY
+ * know what you're doing.
+ *
+ * Example:
+ *	assert(list_empty_nodebug(&parent->children) == (parent->num_children == 0));
+ */
+#ifndef CCAN_LIST_DEBUG
+#define list_empty_nodebug(h) list_empty(h)
+#else
+static inline bool list_empty_nodebug(const struct list_head *h)
+{
+	return h->n.next == &h->n;
+}
+#endif
+
+/**
+ * list_empty_nocheck - is a list empty?
+ * @h: the list_head
+ *
+ * If the list is empty, returns true. This doesn't perform any
+ * debug check for list consistency, so it can be called without
+ * locks, racing with the list being modified. This is ok for
+ * checks where an incorrect result is not an issue (optimized
+ * bail out path for example).
+ */
+static inline bool list_empty_nocheck(const struct list_head *h)
+{
+	return h->n.next == &h->n;
+}
+
+/**
+ * list_del - delete an entry from an (unknown) linked list.
+ * @n: the list_node to delete from the list.
+ *
+ * Note that this leaves @n in an undefined state; it can be added to
+ * another list, but not deleted again.
+ *
+ * See also:
+ *	list_del_from(), list_del_init()
+ *
+ * Example:
+ *	list_del(&child->list);
+ *	parent->num_children--;
+ */
+#define list_del(n) list_del_(n, LIST_LOC)
+static inline void list_del_(struct list_node *n, const char* abortstr)
+{
+	(void)list_debug_node(n, abortstr);
+	n->next->prev = n->prev;
+	n->prev->next = n->next;
+#ifdef CCAN_LIST_DEBUG
+	/* Catch use-after-del. */
+	n->next = n->prev = NULL;
+#endif
+}
+
+/**
+ * list_del_init - delete a node, and reset it so it can be deleted again.
+ * @n: the list_node to be deleted.
+ *
+ * list_del(@n) or list_del_init() again after this will be safe,
+ * which can be useful in some cases.
+ *
+ * See also:
+ *	list_del_from(), list_del()
+ *
+ * Example:
+ *	list_del_init(&child->list);
+ *	parent->num_children--;
+ */
+#define list_del_init(n) list_del_init_(n, LIST_LOC)
+static inline void list_del_init_(struct list_node *n, const char *abortstr)
+{
+	list_del_(n, abortstr);
+	list_node_init(n);
+}
+
+/**
+ * list_del_from - delete an entry from a known linked list.
+ * @h: the list_head the node is in.
+ * @n: the list_node to delete from the list.
+ *
+ * This explicitly indicates which list a node is expected to be in,
+ * which is better documentation and can catch more bugs.
+ *
+ * See also: list_del()
+ *
+ * Example:
+ *	list_del_from(&parent->children, &child->list);
+ *	parent->num_children--;
+ */
+static inline void list_del_from(struct list_head *h, struct list_node *n)
+{
+#ifdef CCAN_LIST_DEBUG
+	{
+		/* Thorough check: make sure it was in list! */
+		struct list_node *i;
+		for (i = h->n.next; i != n; i = i->next)
+			assert(i != &h->n);
+	}
+#endif /* CCAN_LIST_DEBUG */
+
+	/* Quick test that catches a surprising number of bugs. */
+	assert(!list_empty(h));
+	list_del(n);
+}
+
+/**
+ * list_swap - swap out an entry from an (unknown) linked list for a new one.
+ * @o: the list_node to replace from the list.
+ * @n: the list_node to insert in place of the old one.
+ *
+ * Note that this leaves @o in an undefined state; it can be added to
+ * another list, but not deleted/swapped again.
+ *
+ * See also:
+ *	list_del()
+ *
+ * Example:
+ *	struct child x1, x2;
+ *	LIST_HEAD(xh);
+ *
+ *	list_add(&xh, &x1.list);
+ *	list_swap(&x1.list, &x2.list);
+ */
+#define list_swap(o, n) list_swap_(o, n, LIST_LOC)
+static inline void list_swap_(struct list_node *o,
+			      struct list_node *n,
+			      const char* abortstr)
+{
+	(void)list_debug_node(o, abortstr);
+	*n = *o;
+	n->next->prev = n;
+	n->prev->next = n;
+#ifdef CCAN_LIST_DEBUG
+	/* Catch use-after-del. */
+	o->next = o->prev = NULL;
+#endif
+}
+
+/**
+ * list_entry - convert a list_node back into the structure containing it.
+ * @n: the list_node
+ * @type: the type of the entry
+ * @member: the list_node member of the type
+ *
+ * Example:
+ *	// First list entry is children.next; convert back to child.
+ *	child = list_entry(parent->children.n.next, struct child, list);
+ *
+ * See Also:
+ *	list_top(), list_for_each()
+ */
+#define list_entry(n, type, member) container_of(n, type, member)
+
+/**
+ * list_top - get the first entry in a list
+ * @h: the list_head
+ * @type: the type of the entry
+ * @member: the list_node member of the type
+ *
+ * If the list is empty, returns NULL.
+ *
+ * Example:
+ *	struct child *first;
+ *	first = list_top(&parent->children, struct child, list);
+ *	if (!first)
+ *		printf("Empty list!\n");
+ */
+#define list_top(h, type, member)					\
+	((type *)list_top_((h), list_off_(type, member)))
+
+static inline const void *list_top_(const struct list_head *h, size_t off)
+{
+	if (list_empty(h))
+		return NULL;
+	return (const char *)h->n.next - off;
+}
+
+/**
+ * list_pop - remove the first entry in a list
+ * @h: the list_head
+ * @type: the type of the entry
+ * @member: the list_node member of the type
+ *
+ * If the list is empty, returns NULL.
+ *
+ * Example:
+ *	struct child *one;
+ *	one = list_pop(&parent->children, struct child, list);
+ *	if (!one)
+ *		printf("Empty list!\n");
+ */
+#define list_pop(h, type, member)					\
+	((type *)list_pop_((h), list_off_(type, member)))
+
+static inline const void *list_pop_(const struct list_head *h, size_t off)
+{
+	struct list_node *n;
+
+	if (list_empty(h))
+		return NULL;
+	n = h->n.next;
+	list_del(n);
+	return (const char *)n - off;
+}
+
+/**
+ * list_tail - get the last entry in a list
+ * @h: the list_head
+ * @type: the type of the entry
+ * @member: the list_node member of the type
+ *
+ * If the list is empty, returns NULL.
+ *
+ * Example:
+ *	struct child *last;
+ *	last = list_tail(&parent->children, struct child, list);
+ *	if (!last)
+ *		printf("Empty list!\n");
+ */
+#define list_tail(h, type, member) \
+	((type *)list_tail_((h), list_off_(type, member)))
+
+static inline const void *list_tail_(const struct list_head *h, size_t off)
+{
+	if (list_empty(h))
+		return NULL;
+	return (const char *)h->n.prev - off;
+}
+
+/**
+ * list_for_each - iterate through a list.
+ * @h: the list_head (warning: evaluated multiple times!)
+ * @i: the structure containing the list_node
+ * @member: the list_node member of the structure
+ *
+ * This is a convenient wrapper to iterate @i over the entire list.  It's
+ * a for loop, so you can break and continue as normal.
+ *
+ * Example:
+ *	list_for_each(&parent->children, child, list)
+ *		printf("Name: %s\n", child->name);
+ */
+#define list_for_each(h, i, member)					\
+	list_for_each_off(h, i, list_off_var_(i, member))
+
+/**
+ * list_for_each_rev - iterate through a list backwards.
+ * @h: the list_head
+ * @i: the structure containing the list_node
+ * @member: the list_node member of the structure
+ *
+ * This is a convenient wrapper to iterate @i over the entire list.  It's
+ * a for loop, so you can break and continue as normal.
+ *
+ * Example:
+ *	list_for_each_rev(&parent->children, child, list)
+ *		printf("Name: %s\n", child->name);
+ */
+#define list_for_each_rev(h, i, member)					\
+	list_for_each_rev_off(h, i, list_off_var_(i, member))
+
+/**
+ * list_for_each_rev_safe - iterate through a list backwards,
+ * maybe during deletion
+ * @h: the list_head
+ * @i: the structure containing the list_node
+ * @nxt: the structure containing the list_node
+ * @member: the list_node member of the structure
+ *
+ * This is a convenient wrapper to iterate @i over the entire list backwards.
+ * It's a for loop, so you can break and continue as normal.  The extra
+ * variable * @nxt is used to hold the next element, so you can delete @i
+ * from the list.
+ *
+ * Example:
+ *	struct child *next;
+ *	list_for_each_rev_safe(&parent->children, child, next, list) {
+ *		printf("Name: %s\n", child->name);
+ *	}
+ */
+#define list_for_each_rev_safe(h, i, nxt, member)			\
+	list_for_each_rev_safe_off(h, i, nxt, list_off_var_(i, member))
+
+/**
+ * list_for_each_safe - iterate through a list, maybe during deletion
+ * @h: the list_head
+ * @i: the structure containing the list_node
+ * @nxt: the structure containing the list_node
+ * @member: the list_node member of the structure
+ *
+ * This is a convenient wrapper to iterate @i over the entire list.  It's
+ * a for loop, so you can break and continue as normal.  The extra variable
+ * @nxt is used to hold the next element, so you can delete @i from the list.
+ *
+ * Example:
+ *	list_for_each_safe(&parent->children, child, next, list) {
+ *		list_del(&child->list);
+ *		parent->num_children--;
+ *	}
+ */
+#define list_for_each_safe(h, i, nxt, member)				\
+	list_for_each_safe_off(h, i, nxt, list_off_var_(i, member))
+
+/**
+ * list_next - get the next entry in a list
+ * @h: the list_head
+ * @i: a pointer to an entry in the list.
+ * @member: the list_node member of the structure
+ *
+ * If @i was the last entry in the list, returns NULL.
+ *
+ * Example:
+ *	struct child *second;
+ *	second = list_next(&parent->children, first, list);
+ *	if (!second)
+ *		printf("No second child!\n");
+ */
+#define list_next(h, i, member)						\
+	((list_typeof(i))list_entry_or_null(list_debug(h,		\
+					    __FILE__ ":" stringify(__LINE__)), \
+					    (i)->member.next,		\
+					    list_off_var_((i), member)))
+
+/**
+ * list_prev - get the previous entry in a list
+ * @h: the list_head
+ * @i: a pointer to an entry in the list.
+ * @member: the list_node member of the structure
+ *
+ * If @i was the first entry in the list, returns NULL.
+ *
+ * Example:
+ *	first = list_prev(&parent->children, second, list);
+ *	if (!first)
+ *		printf("Can't go back to first child?!\n");
+ */
+#define list_prev(h, i, member)						\
+	((list_typeof(i))list_entry_or_null(list_debug(h,		\
+					    __FILE__ ":" stringify(__LINE__)), \
+					    (i)->member.prev,		\
+					    list_off_var_((i), member)))
+
+/**
+ * list_append_list - empty one list onto the end of another.
+ * @to: the list to append into
+ * @from: the list to empty.
+ *
+ * This takes the entire contents of @from and moves it to the end of
+ * @to.  After this @from will be empty.
+ *
+ * Example:
+ *	struct list_head adopter;
+ *
+ *	list_append_list(&adopter, &parent->children);
+ *	assert(list_empty(&parent->children));
+ *	parent->num_children = 0;
+ */
+#define list_append_list(t, f) list_append_list_(t, f,			\
+				   __FILE__ ":" stringify(__LINE__))
+static inline void list_append_list_(struct list_head *to,
+				     struct list_head *from,
+				     const char *abortstr)
+{
+	struct list_node *from_tail = list_debug(from, abortstr)->n.prev;
+	struct list_node *to_tail = list_debug(to, abortstr)->n.prev;
+
+	/* Sew in head and entire list. */
+	to->n.prev = from_tail;
+	from_tail->next = &to->n;
+	to_tail->next = &from->n;
+	from->n.prev = to_tail;
+
+	/* Now remove head. */
+	list_del(&from->n);
+	list_head_init(from);
+}
+
+/**
+ * list_prepend_list - empty one list into the start of another.
+ * @to: the list to prepend into
+ * @from: the list to empty.
+ *
+ * This takes the entire contents of @from and moves it to the start
+ * of @to.  After this @from will be empty.
+ *
+ * Example:
+ *	list_prepend_list(&adopter, &parent->children);
+ *	assert(list_empty(&parent->children));
+ *	parent->num_children = 0;
+ */
+#define list_prepend_list(t, f) list_prepend_list_(t, f, LIST_LOC)
+static inline void list_prepend_list_(struct list_head *to,
+				      struct list_head *from,
+				      const char *abortstr)
+{
+	struct list_node *from_tail = list_debug(from, abortstr)->n.prev;
+	struct list_node *to_head = list_debug(to, abortstr)->n.next;
+
+	/* Sew in head and entire list. */
+	to->n.next = &from->n;
+	from->n.prev = &to->n;
+	to_head->prev = from_tail;
+	from_tail->next = to_head;
+
+	/* Now remove head. */
+	list_del(&from->n);
+	list_head_init(from);
+}
+
+/* internal macros, do not use directly */
+#define list_for_each_off_dir_(h, i, off, dir)				\
+	for (i = list_node_to_off_(list_debug(h, LIST_LOC)->n.dir,	\
+				   (off));				\
+	list_node_from_off_((void *)i, (off)) != &(h)->n;		\
+	i = list_node_to_off_(list_node_from_off_((void *)i, (off))->dir, \
+			      (off)))
+
+#define list_for_each_safe_off_dir_(h, i, nxt, off, dir)		\
+	for (i = list_node_to_off_(list_debug(h, LIST_LOC)->n.dir,	\
+				   (off)),				\
+	nxt = list_node_to_off_(list_node_from_off_(i, (off))->dir,	\
+				(off));					\
+	list_node_from_off_(i, (off)) != &(h)->n;			\
+	i = nxt,							\
+	nxt = list_node_to_off_(list_node_from_off_(i, (off))->dir,	\
+				(off)))
+
+/**
+ * list_for_each_off - iterate through a list of memory regions.
+ * @h: the list_head
+ * @i: the pointer to a memory region wich contains list node data.
+ * @off: offset(relative to @i) at which list node data resides.
+ *
+ * This is a low-level wrapper to iterate @i over the entire list, used to
+ * implement all oher, more high-level, for-each constructs. It's a for loop,
+ * so you can break and continue as normal.
+ *
+ * WARNING! Being the low-level macro that it is, this wrapper doesn't know
+ * nor care about the type of @i. The only assumtion made is that @i points
+ * to a chunk of memory that at some @offset, relative to @i, contains a
+ * properly filled `struct node_list' which in turn contains pointers to
+ * memory chunks and it's turtles all the way down. Whith all that in mind
+ * remember that given the wrong pointer/offset couple this macro will
+ * happilly churn all you memory untill SEGFAULT stops it, in other words
+ * caveat emptor.
+ *
+ * It is worth mentioning that one of legitimate use-cases for that wrapper
+ * is operation on opaque types with known offset for `struct list_node'
+ * member(preferably 0), because it allows you not to disclose the type of
+ * @i.
+ *
+ * Example:
+ *	list_for_each_off(&parent->children, child,
+ *				offsetof(struct child, list))
+ *		printf("Name: %s\n", child->name);
+ */
+#define list_for_each_off(h, i, off)                                    \
+	list_for_each_off_dir_((h),(i),(off),next)
+
+/**
+ * list_for_each_rev_off - iterate through a list of memory regions backwards
+ * @h: the list_head
+ * @i: the pointer to a memory region wich contains list node data.
+ * @off: offset(relative to @i) at which list node data resides.
+ *
+ * See list_for_each_off for details
+ */
+#define list_for_each_rev_off(h, i, off)                                    \
+	list_for_each_off_dir_((h),(i),(off),prev)
+
+/**
+ * list_for_each_safe_off - iterate through a list of memory regions, maybe
+ * during deletion
+ * @h: the list_head
+ * @i: the pointer to a memory region wich contains list node data.
+ * @nxt: the structure containing the list_node
+ * @off: offset(relative to @i) at which list node data resides.
+ *
+ * For details see `list_for_each_off' and `list_for_each_safe'
+ * descriptions.
+ *
+ * Example:
+ *	list_for_each_safe_off(&parent->children, child,
+ *		next, offsetof(struct child, list))
+ *		printf("Name: %s\n", child->name);
+ */
+#define list_for_each_safe_off(h, i, nxt, off)                          \
+	list_for_each_safe_off_dir_((h),(i),(nxt),(off),next)
+
+/**
+ * list_for_each_rev_safe_off - iterate backwards through a list of
+ * memory regions, maybe during deletion
+ * @h: the list_head
+ * @i: the pointer to a memory region wich contains list node data.
+ * @nxt: the structure containing the list_node
+ * @off: offset(relative to @i) at which list node data resides.
+ *
+ * For details see `list_for_each_rev_off' and `list_for_each_rev_safe'
+ * descriptions.
+ *
+ * Example:
+ *	list_for_each_rev_safe_off(&parent->children, child,
+ *		next, offsetof(struct child, list))
+ *		printf("Name: %s\n", child->name);
+ */
+#define list_for_each_rev_safe_off(h, i, nxt, off)                      \
+	list_for_each_safe_off_dir_((h),(i),(nxt),(off),prev)
+
+/* Other -off variants. */
+#define list_entry_off(n, type, off)		\
+	((type *)list_node_from_off_((n), (off)))
+
+#define list_head_off(h, type, off)		\
+	((type *)list_head_off((h), (off)))
+
+#define list_tail_off(h, type, off)		\
+	((type *)list_tail_((h), (off)))
+
+#define list_add_off(h, n, off)                 \
+	list_add((h), list_node_from_off_((n), (off)))
+
+#define list_del_off(n, off)                    \
+	list_del(list_node_from_off_((n), (off)))
+
+#define list_del_from_off(h, n, off)			\
+	list_del_from(h, list_node_from_off_((n), (off)))
+
+/* Offset helper functions so we only single-evaluate. */
+static inline void *list_node_to_off_(struct list_node *node, size_t off)
+{
+	return (void *)((char *)node - off);
+}
+static inline struct list_node *list_node_from_off_(void *ptr, size_t off)
+{
+	return (struct list_node *)((char *)ptr + off);
+}
+
+/* Get the offset of the member, but make sure it's a list_node. */
+#define list_off_(type, member)					\
+	(container_off(type, member) +				\
+	 check_type(((type *)0)->member, struct list_node))
+
+#define list_off_var_(var, member)			\
+	(container_off_var(var, member) +		\
+	 check_type(var->member, struct list_node))
+
+#if HAVE_TYPEOF
+#define list_typeof(var) typeof(var)
+#else
+#define list_typeof(var) void *
+#endif
+
+/* Returns member, or NULL if at end of list. */
+static inline void *list_entry_or_null(const struct list_head *h,
+				       const struct list_node *n,
+				       size_t off)
+{
+	if (n == &h->n)
+		return NULL;
+	return (char *)n - off;
+}
+#endif /* CCAN_LIST_H */
diff --git a/ccan/str.c b/ccan/str.c
new file mode 100644
index 0000000..e1daadb
--- /dev/null
+++ b/ccan/str.c
@@ -0,0 +1,13 @@
+/* CC0 (Public domain) - see LICENSE file for details */
+#include <ccan/str.h>
+
+size_t strcount(const char *haystack, const char *needle)
+{
+	size_t i = 0, nlen = strlen(needle);
+
+	while ((haystack = strstr(haystack, needle)) != NULL) {
+		i++;
+		haystack += nlen;
+	}
+	return i;
+}
diff --git a/ccan/str.h b/ccan/str.h
new file mode 100644
index 0000000..4e268b3
--- /dev/null
+++ b/ccan/str.h
@@ -0,0 +1,228 @@
+/* CC0 (Public domain) - see LICENSE file for details */
+#ifndef CCAN_STR_H
+#define CCAN_STR_H
+#include "config.h"
+#include <string.h>
+#include <stdbool.h>
+#include <limits.h>
+#include <ctype.h>
+
+/**
+ * streq - Are two strings equal?
+ * @a: first string
+ * @b: first string
+ *
+ * This macro is arguably more readable than "!strcmp(a, b)".
+ *
+ * Example:
+ *	if (streq(somestring, ""))
+ *		printf("String is empty!\n");
+ */
+#define streq(a,b) (strcmp((a),(b)) == 0)
+
+/**
+ * strstarts - Does this string start with this prefix?
+ * @str: string to test
+ * @prefix: prefix to look for at start of str
+ *
+ * Example:
+ *	if (strstarts(somestring, "foo"))
+ *		printf("String %s begins with 'foo'!\n", somestring);
+ */
+#define strstarts(str,prefix) (strncmp((str),(prefix),strlen(prefix)) == 0)
+
+/**
+ * strends - Does this string end with this postfix?
+ * @str: string to test
+ * @postfix: postfix to look for at end of str
+ *
+ * Example:
+ *	if (strends(somestring, "foo"))
+ *		printf("String %s end with 'foo'!\n", somestring);
+ */
+static inline bool strends(const char *str, const char *postfix)
+{
+	if (strlen(str) < strlen(postfix))
+		return false;
+
+	return streq(str + strlen(str) - strlen(postfix), postfix);
+}
+
+/**
+ * stringify - Turn expression into a string literal
+ * @expr: any C expression
+ *
+ * Example:
+ *	#define PRINT_COND_IF_FALSE(cond) \
+ *		((cond) || printf("%s is false!", stringify(cond)))
+ */
+#define stringify(expr)		stringify_1(expr)
+/* Double-indirection required to stringify expansions */
+#define stringify_1(expr)	#expr
+
+/**
+ * strcount - Count number of (non-overlapping) occurrences of a substring.
+ * @haystack: a C string
+ * @needle: a substring
+ *
+ * Example:
+ *      assert(strcount("aaa aaa", "a") == 6);
+ *      assert(strcount("aaa aaa", "ab") == 0);
+ *      assert(strcount("aaa aaa", "aa") == 2);
+ */
+size_t strcount(const char *haystack, const char *needle);
+
+/**
+ * STR_MAX_CHARS - Maximum possible size of numeric string for this type.
+ * @type_or_expr: a pointer or integer type or expression.
+ *
+ * This provides enough space for a nul-terminated string which represents the
+ * largest possible value for the type or expression.
+ *
+ * Note: The implementation adds extra space so hex values or negative
+ * values will fit (eg. sprintf(... "%p"). )
+ *
+ * Example:
+ *	char str[STR_MAX_CHARS(int)];
+ *
+ *	sprintf(str, "%i", 7);
+ */
+#define STR_MAX_CHARS(type_or_expr)				\
+	((sizeof(type_or_expr) * CHAR_BIT + 8) / 9 * 3 + 2	\
+	 + STR_MAX_CHARS_TCHECK_(type_or_expr))
+
+#if HAVE_TYPEOF
+/* Only a simple type can have 0 assigned, so test that. */
+#define STR_MAX_CHARS_TCHECK_(type_or_expr)		\
+	({ typeof(type_or_expr) x = 0; (void)x; 0; })
+#else
+#define STR_MAX_CHARS_TCHECK_(type_or_expr) 0
+#endif
+
+/**
+ * cisalnum - isalnum() which takes a char (and doesn't accept EOF)
+ * @c: a character
+ *
+ * Surprisingly, the standard ctype.h isalnum() takes an int, which
+ * must have the value of EOF (-1) or an unsigned char.  This variant
+ * takes a real char, and doesn't accept EOF.
+ */
+static inline bool cisalnum(char c)
+{
+	return isalnum((unsigned char)c);
+}
+static inline bool cisalpha(char c)
+{
+	return isalpha((unsigned char)c);
+}
+static inline bool cisascii(char c)
+{
+	return isascii((unsigned char)c);
+}
+#if HAVE_ISBLANK
+static inline bool cisblank(char c)
+{
+	return isblank((unsigned char)c);
+}
+#endif
+static inline bool ciscntrl(char c)
+{
+	return iscntrl((unsigned char)c);
+}
+static inline bool cisdigit(char c)
+{
+	return isdigit((unsigned char)c);
+}
+static inline bool cisgraph(char c)
+{
+	return isgraph((unsigned char)c);
+}
+static inline bool cislower(char c)
+{
+	return islower((unsigned char)c);
+}
+static inline bool cisprint(char c)
+{
+	return isprint((unsigned char)c);
+}
+static inline bool cispunct(char c)
+{
+	return ispunct((unsigned char)c);
+}
+static inline bool cisspace(char c)
+{
+	return isspace((unsigned char)c);
+}
+static inline bool cisupper(char c)
+{
+	return isupper((unsigned char)c);
+}
+static inline bool cisxdigit(char c)
+{
+	return isxdigit((unsigned char)c);
+}
+
+#include <ccan/str_debug.h>
+
+/* These checks force things out of line, hence they are under DEBUG. */
+#ifdef CCAN_STR_DEBUG
+#include <ccan/build_assert.h>
+
+/* These are commonly misused: they take -1 or an *unsigned* char value. */
+#undef isalnum
+#undef isalpha
+#undef isascii
+#undef isblank
+#undef iscntrl
+#undef isdigit
+#undef isgraph
+#undef islower
+#undef isprint
+#undef ispunct
+#undef isspace
+#undef isupper
+#undef isxdigit
+
+/* You can use a char if char is unsigned. */
+#if HAVE_BUILTIN_TYPES_COMPATIBLE_P && HAVE_TYPEOF
+#define str_check_arg_(i)						\
+	((i) + BUILD_ASSERT_OR_ZERO(!__builtin_types_compatible_p(typeof(i), \
+								  char)	\
+				    || (char)255 > 0))
+#else
+#define str_check_arg_(i) (i)
+#endif
+
+#define isalnum(i) str_isalnum(str_check_arg_(i))
+#define isalpha(i) str_isalpha(str_check_arg_(i))
+#define isascii(i) str_isascii(str_check_arg_(i))
+#if HAVE_ISBLANK
+#define isblank(i) str_isblank(str_check_arg_(i))
+#endif
+#define iscntrl(i) str_iscntrl(str_check_arg_(i))
+#define isdigit(i) str_isdigit(str_check_arg_(i))
+#define isgraph(i) str_isgraph(str_check_arg_(i))
+#define islower(i) str_islower(str_check_arg_(i))
+#define isprint(i) str_isprint(str_check_arg_(i))
+#define ispunct(i) str_ispunct(str_check_arg_(i))
+#define isspace(i) str_isspace(str_check_arg_(i))
+#define isupper(i) str_isupper(str_check_arg_(i))
+#define isxdigit(i) str_isxdigit(str_check_arg_(i))
+
+#if HAVE_TYPEOF
+/* With GNU magic, we can make const-respecting standard string functions. */
+#undef strstr
+#undef strchr
+#undef strrchr
+
+/* + 0 is needed to decay array into pointer. */
+#define strstr(haystack, needle)					\
+	((typeof((haystack) + 0))str_strstr((haystack), (needle)))
+#define strchr(haystack, c)					\
+	((typeof((haystack) + 0))str_strchr((haystack), (c)))
+#define strrchr(haystack, c)					\
+	((typeof((haystack) + 0))str_strrchr((haystack), (c)))
+#endif
+#endif /* CCAN_STR_DEBUG */
+
+#endif /* CCAN_STR_H */
diff --git a/ccan/str_debug.h b/ccan/str_debug.h
new file mode 100644
index 0000000..92c10c4
--- /dev/null
+++ b/ccan/str_debug.h
@@ -0,0 +1,30 @@
+/* CC0 (Public domain) - see LICENSE file for details */
+#ifndef CCAN_STR_DEBUG_H
+#define CCAN_STR_DEBUG_H
+
+/* #define CCAN_STR_DEBUG 1 */
+
+#ifdef CCAN_STR_DEBUG
+/* Because we mug the real ones with macros, we need our own wrappers. */
+int str_isalnum(int i);
+int str_isalpha(int i);
+int str_isascii(int i);
+#if HAVE_ISBLANK
+int str_isblank(int i);
+#endif
+int str_iscntrl(int i);
+int str_isdigit(int i);
+int str_isgraph(int i);
+int str_islower(int i);
+int str_isprint(int i);
+int str_ispunct(int i);
+int str_isspace(int i);
+int str_isupper(int i);
+int str_isxdigit(int i);
+
+char *str_strstr(const char *haystack, const char *needle);
+char *str_strchr(const char *s, int c);
+char *str_strrchr(const char *s, int c);
+#endif /* CCAN_STR_DEBUG */
+
+#endif /* CCAN_STR_DEBUG_H */
diff --git a/ibacm/CMakeLists.txt b/ibacm/CMakeLists.txt
index 8887c13..3a8ac32 100644
--- a/ibacm/CMakeLists.txt
+++ b/ibacm/CMakeLists.txt
@@ -18,7 +18,7 @@ rdma_sbin_executable(ibacm
   src/acm.c
   src/acm_util.c
   )
-target_link_libraries(ibacm
+target_link_libraries(ibacm LINK_PRIVATE
   ibverbs
   ibumad
   ${CMAKE_THREAD_LIBS_INIT}
@@ -32,7 +32,7 @@ add_library(ibacmp MODULE
   prov/acmp/src/acmp.c
   )
 rdma_set_library_map(ibacmp "prov/acmp/src/libibacmp.map")
-target_link_libraries(ibacmp
+target_link_libraries(ibacmp LINK_PRIVATE
   ibacm
   ibverbs
   ibumad
@@ -48,7 +48,7 @@ rdma_executable(ib_acme
   src/libacm.c
   src/parse.c
   )
-target_link_libraries(ib_acme
+target_link_libraries(ib_acme LINK_PRIVATE
   ibverbs
   )
 target_compile_definitions(ib_acme PRIVATE "-DACME_PRINTS")
diff --git a/iwpmd/src/CMakeLists.txt b/iwpmd/src/CMakeLists.txt
index e6255b5..727db7e 100644
--- a/iwpmd/src/CMakeLists.txt
+++ b/iwpmd/src/CMakeLists.txt
@@ -3,7 +3,7 @@ rdma_executable(iwpmd
   iwarp_pm_helper.c
   iwarp_pm_server.c
   )
-target_link_libraries(iwpmd
+target_link_libraries(iwpmd LINK_PRIVATE
   ${NL_LIBRARIES}
   ${CMAKE_THREAD_LIBS_INIT}
   )
diff --git a/libibcm/examples/CMakeLists.txt b/libibcm/examples/CMakeLists.txt
index a90639d..ef30a6e 100644
--- a/libibcm/examples/CMakeLists.txt
+++ b/libibcm/examples/CMakeLists.txt
@@ -1,2 +1,2 @@
 rdma_test_executable(cmpost cmpost.c)
-target_link_libraries(cmpost ibcm rdmacm)
+target_link_libraries(cmpost LINK_PRIVATE ibcm rdmacm)
diff --git a/libibumad/tests/CMakeLists.txt b/libibumad/tests/CMakeLists.txt
index 9676029..7508e08 100644
--- a/libibumad/tests/CMakeLists.txt
+++ b/libibumad/tests/CMakeLists.txt
@@ -1,5 +1,5 @@
 rdma_test_executable(umad_reg2 umad_reg2_compat.c)
-target_link_libraries(umad_reg2 ibumad)
+target_link_libraries(umad_reg2 LINK_PRIVATE ibumad)
 
 rdma_test_executable(umad_register2 umad_register2.c)
-target_link_libraries(umad_register2 ibumad)
+target_link_libraries(umad_register2 LINK_PRIVATE ibumad)
diff --git a/libibverbs/examples/CMakeLists.txt b/libibverbs/examples/CMakeLists.txt
index 5fc47ba..76e333b 100644
--- a/libibverbs/examples/CMakeLists.txt
+++ b/libibverbs/examples/CMakeLists.txt
@@ -6,25 +6,25 @@ add_library(ibverbs_tools STATIC
   )
 
 rdma_executable(ibv_asyncwatch asyncwatch.c)
-target_link_libraries(ibv_asyncwatch ibverbs)
+target_link_libraries(ibv_asyncwatch LINK_PRIVATE ibverbs)
 
 rdma_executable(ibv_devices device_list.c)
-target_link_libraries(ibv_devices ibverbs)
+target_link_libraries(ibv_devices LINK_PRIVATE ibverbs)
 
 rdma_executable(ibv_devinfo devinfo.c)
-target_link_libraries(ibv_devinfo ibverbs)
+target_link_libraries(ibv_devinfo LINK_PRIVATE ibverbs)
 
 rdma_executable(ibv_rc_pingpong rc_pingpong.c)
-target_link_libraries(ibv_rc_pingpong ibverbs ibverbs_tools)
+target_link_libraries(ibv_rc_pingpong LINK_PRIVATE ibverbs ibverbs_tools)
 
 rdma_executable(ibv_srq_pingpong srq_pingpong.c)
-target_link_libraries(ibv_srq_pingpong ibverbs ibverbs_tools)
+target_link_libraries(ibv_srq_pingpong LINK_PRIVATE ibverbs ibverbs_tools)
 
 rdma_executable(ibv_uc_pingpong uc_pingpong.c)
-target_link_libraries(ibv_uc_pingpong ibverbs ibverbs_tools)
+target_link_libraries(ibv_uc_pingpong LINK_PRIVATE ibverbs ibverbs_tools)
 
 rdma_executable(ibv_ud_pingpong ud_pingpong.c)
-target_link_libraries(ibv_ud_pingpong ibverbs ibverbs_tools)
+target_link_libraries(ibv_ud_pingpong LINK_PRIVATE ibverbs ibverbs_tools)
 
 rdma_executable(ibv_xsrq_pingpong xsrq_pingpong.c)
-target_link_libraries(ibv_xsrq_pingpong ibverbs ibverbs_tools)
+target_link_libraries(ibv_xsrq_pingpong LINK_PRIVATE ibverbs ibverbs_tools)
diff --git a/librdmacm/examples/CMakeLists.txt b/librdmacm/examples/CMakeLists.txt
index 31c9606..3997175 100644
--- a/librdmacm/examples/CMakeLists.txt
+++ b/librdmacm/examples/CMakeLists.txt
@@ -4,40 +4,40 @@ add_library(rdmacm_tools STATIC
   )
 
 rdma_executable(cmtime cmtime.c)
-target_link_libraries(cmtime rdmacm ${CMAKE_THREAD_LIBS_INIT} rdmacm_tools)
+target_link_libraries(cmtime LINK_PRIVATE rdmacm ${CMAKE_THREAD_LIBS_INIT} rdmacm_tools)
 
 rdma_executable(mckey mckey.c)
-target_link_libraries(mckey rdmacm ${CMAKE_THREAD_LIBS_INIT})
+target_link_libraries(mckey LINK_PRIVATE rdmacm ${CMAKE_THREAD_LIBS_INIT})
 
 rdma_executable(rcopy rcopy.c)
-target_link_libraries(rcopy rdmacm)
+target_link_libraries(rcopy LINK_PRIVATE rdmacm)
 
 rdma_executable(rdma_client rdma_client.c)
-target_link_libraries(rdma_client rdmacm)
+target_link_libraries(rdma_client LINK_PRIVATE rdmacm)
 
 rdma_executable(rdma_server rdma_server.c)
-target_link_libraries(rdma_server rdmacm)
+target_link_libraries(rdma_server LINK_PRIVATE rdmacm)
 
 rdma_executable(rdma_xclient rdma_xclient.c)
-target_link_libraries(rdma_xclient rdmacm)
+target_link_libraries(rdma_xclient LINK_PRIVATE rdmacm)
 
 rdma_executable(rdma_xserver rdma_xserver.c)
-target_link_libraries(rdma_xserver rdmacm)
+target_link_libraries(rdma_xserver LINK_PRIVATE rdmacm)
 
 rdma_executable(riostream riostream.c)
-target_link_libraries(riostream rdmacm rdmacm_tools)
+target_link_libraries(riostream LINK_PRIVATE rdmacm rdmacm_tools)
 
 rdma_executable(rping rping.c)
-target_link_libraries(rping rdmacm ${CMAKE_THREAD_LIBS_INIT})
+target_link_libraries(rping LINK_PRIVATE rdmacm ${CMAKE_THREAD_LIBS_INIT})
 
 rdma_executable(rstream rstream.c)
-target_link_libraries(rstream rdmacm rdmacm_tools)
+target_link_libraries(rstream LINK_PRIVATE rdmacm rdmacm_tools)
 
 rdma_executable(ucmatose cmatose.c)
-target_link_libraries(ucmatose rdmacm rdmacm_tools)
+target_link_libraries(ucmatose LINK_PRIVATE rdmacm rdmacm_tools)
 
 rdma_executable(udaddy udaddy.c)
-target_link_libraries(udaddy rdmacm rdmacm_tools)
+target_link_libraries(udaddy LINK_PRIVATE rdmacm rdmacm_tools)
 
 rdma_executable(udpong udpong.c)
-target_link_libraries(udpong rdmacm rdmacm_tools)
+target_link_libraries(udpong LINK_PRIVATE rdmacm rdmacm_tools)
diff --git a/srp_daemon/srp_daemon/CMakeLists.txt b/srp_daemon/srp_daemon/CMakeLists.txt
index 84d7404..b02725b 100644
--- a/srp_daemon/srp_daemon/CMakeLists.txt
+++ b/srp_daemon/srp_daemon/CMakeLists.txt
@@ -5,7 +5,7 @@ rdma_sbin_executable(srp_daemon
   srp_handle_traps.c
   srp_sync.c
   )
-target_link_libraries(srp_daemon
+target_link_libraries(srp_daemon LINK_PRIVATE
   ibverbs
   ibumad
   ${RT_LIBRARIES}
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
