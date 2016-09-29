From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 rdma-core 4/5] libmlx5: Move to use CCAN list functionality
Date: Thu, 29 Sep 2016 14:11:01 +0300
Message-ID: <1475147462-803-5-git-send-email-yishaih@mellanox.com>
References: <1475147462-803-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475147462-803-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Move to use CCAN list functionality which its license meets
the project needs.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libmlx5/src/buf.c  |  11 +-
 libmlx5/src/list.h | 312 -----------------------------------------------------
 libmlx5/src/mlx5.c |   2 +-
 libmlx5/src/mlx5.h |   4 +-
 4 files changed, 8 insertions(+), 321 deletions(-)
 delete mode 100644 libmlx5/src/list.h

diff --git a/libmlx5/src/buf.c b/libmlx5/src/buf.c
index c827930..1a681c6 100644
--- a/libmlx5/src/buf.c
+++ b/libmlx5/src/buf.c
@@ -259,7 +259,6 @@ static int alloc_huge_buf(struct mlx5_context *mctx, struct mlx5_buf *buf,
 			  size_t size, int page_size)
 {
 	int found = 0;
-	LIST_HEAD(slist);
 	int nchunk;
 	struct mlx5_hugetlb_mem *hmem;
 	int ret;
@@ -268,7 +267,7 @@ static int alloc_huge_buf(struct mlx5_context *mctx, struct mlx5_buf *buf,
 	nchunk = buf->length / MLX5_Q_CHUNK_SIZE;
 
 	mlx5_spin_lock(&mctx->hugetlb_lock);
-	list_for_each_entry(hmem, &mctx->hugetlb_list, list) {
+	list_for_each(&mctx->hugetlb_list, hmem, entry) {
 		if (bitmap_avail(&hmem->bitmap)) {
 			buf->base = bitmap_alloc_range(&hmem->bitmap, nchunk, 1);
 			if (buf->base != -1) {
@@ -297,9 +296,9 @@ static int alloc_huge_buf(struct mlx5_context *mctx, struct mlx5_buf *buf,
 
 		mlx5_spin_lock(&mctx->hugetlb_lock);
 		if (bitmap_avail(&hmem->bitmap))
-			list_add(&hmem->list, &mctx->hugetlb_list);
+			list_add(&mctx->hugetlb_list, &hmem->entry);
 		else
-			list_add_tail(&hmem->list, &mctx->hugetlb_list);
+			list_add_tail(&mctx->hugetlb_list, &hmem->entry);
 		mlx5_spin_unlock(&mctx->hugetlb_lock);
 	}
 
@@ -318,7 +317,7 @@ out_fork:
 	mlx5_spin_lock(&mctx->hugetlb_lock);
 	bitmap_free_range(&hmem->bitmap, buf->base, nchunk);
 	if (bitmap_empty(&hmem->bitmap)) {
-		list_del(&hmem->list);
+		list_del(&hmem->entry);
 		mlx5_spin_unlock(&mctx->hugetlb_lock);
 		free_huge_mem(hmem);
 	} else
@@ -335,7 +334,7 @@ static void free_huge_buf(struct mlx5_context *ctx, struct mlx5_buf *buf)
 	mlx5_spin_lock(&ctx->hugetlb_lock);
 	bitmap_free_range(&buf->hmem->bitmap, buf->base, nchunk);
 	if (bitmap_empty(&buf->hmem->bitmap)) {
-		list_del(&buf->hmem->list);
+		list_del(&buf->hmem->entry);
 		mlx5_spin_unlock(&ctx->hugetlb_lock);
 		free_huge_mem(buf->hmem);
 	} else
diff --git a/libmlx5/src/list.h b/libmlx5/src/list.h
deleted file mode 100644
index 4f96482..0000000
--- a/libmlx5/src/list.h
+++ /dev/null
@@ -1,312 +0,0 @@
-#ifndef _LINUX_LIST_H
-#define _LINUX_LIST_H
-
-/*
- * These are non-NULL pointers that will result in page faults
- * under normal circumstances, used to verify that nobody uses
- * non-initialized list entries.
- */
-#define LIST_POISON1  ((void *) 0x00100100)
-#define LIST_POISON2  ((void *) 0x00200200)
-
-/*
- * Simple doubly linked list implementation.
- *
- * Some of the internal functions ("__xxx") are useful when
- * manipulating whole lists rather than single entries, as
- * sometimes we already know the next/prev entries and we can
- * generate better code by using them directly rather than
- * using the generic single-entry routines.
- */
-
-struct list_head {
-	struct list_head *next, *prev;
-};
-
-#define LIST_HEAD_INIT(name) { &(name), &(name) }
-
-#define LIST_HEAD(name) \
-	struct list_head name = LIST_HEAD_INIT(name)
-
-#define INIT_LIST_HEAD(ptr) do { \
-	(ptr)->next = (ptr); (ptr)->prev = (ptr); \
-} while (0)
-
-/*
- * Insert a new entry between two known consecutive entries.
- *
- * This is only for internal list manipulation where we know
- * the prev/next entries already!
- */
-static inline void __list_add(struct list_head *new,
-			      struct list_head *prev,
-			      struct list_head *next)
-{
-	next->prev = new;
-	new->next = next;
-	new->prev = prev;
-	prev->next = new;
-}
-
-/**
- * list_add - add a new entry
- * @new: new entry to be added
- * @head: list head to add it after
- *
- * Insert a new entry after the specified head.
- * This is good for implementing stacks.
- */
-static inline void list_add(struct list_head *new, struct list_head *head)
-{
-	__list_add(new, head, head->next);
-}
-
-/**
- * list_add_tail - add a new entry
- * @new: new entry to be added
- * @head: list head to add it before
- *
- * Insert a new entry before the specified head.
- * This is useful for implementing queues.
- */
-static inline void list_add_tail(struct list_head *new, struct list_head *head)
-{
-	__list_add(new, head->prev, head);
-}
-
-/*
- * Delete a list entry by making the prev/next entries
- * point to each other.
- *
- * This is only for internal list manipulation where we know
- * the prev/next entries already!
- */
-static inline void __list_del(struct list_head *prev, struct list_head *next)
-{
-	next->prev = prev;
-	prev->next = next;
-}
-
-/**
- * list_del - deletes entry from list.
- * @entry: the element to delete from the list.
- * Note: list_empty on entry does not return true after this, the entry is
- * in an undefined state.
- */
-static inline void list_del(struct list_head *entry)
-{
-	__list_del(entry->prev, entry->next);
-	entry->next = LIST_POISON1;
-	entry->prev = LIST_POISON2;
-}
-
-/**
- * list_del_init - deletes entry from list and reinitialize it.
- * @entry: the element to delete from the list.
- */
-static inline void list_del_init(struct list_head *entry)
-{
-	__list_del(entry->prev, entry->next);
-	INIT_LIST_HEAD(entry);
-}
-
-/**
- * list_move - delete from one list and add as another's head
- * @list: the entry to move
- * @head: the head that will precede our entry
- */
-static inline void list_move(struct list_head *list, struct list_head *head)
-{
-	__list_del(list->prev, list->next);
-	list_add(list, head);
-}
-
-/**
- * list_move_tail - delete from one list and add as another's tail
- * @list: the entry to move
- * @head: the head that will follow our entry
- */
-static inline void list_move_tail(struct list_head *list,
-				  struct list_head *head)
-{
-	__list_del(list->prev, list->next);
-	list_add_tail(list, head);
-}
-
-/**
- * list_empty - tests whether a list is empty
- * @head: the list to test.
- */
-static inline int list_empty(const struct list_head *head)
-{
-	return head->next == head;
-}
-
-/**
- * list_empty_careful - tests whether a list is
- * empty _and_ checks that no other CPU might be
- * in the process of still modifying either member
- *
- * NOTE: using list_empty_careful() without synchronization
- * can only be safe if the only activity that can happen
- * to the list entry is list_del_init(). Eg. it cannot be used
- * if another CPU could re-list_add() it.
- *
- * @head: the list to test.
- */
-static inline int list_empty_careful(const struct list_head *head)
-{
-	struct list_head *next = head->next;
-	return (next == head) && (next == head->prev);
-}
-
-static inline void __list_splice(struct list_head *list,
-				 struct list_head *head)
-{
-	struct list_head *first = list->next;
-	struct list_head *last = list->prev;
-	struct list_head *at = head->next;
-
-	first->prev = head;
-	head->next = first;
-
-	last->next = at;
-	at->prev = last;
-}
-
-/**
- * list_splice - join two lists
- * @list: the new list to add.
- * @head: the place to add it in the first list.
- */
-static inline void list_splice(struct list_head *list, struct list_head *head)
-{
-	if (!list_empty(list))
-		__list_splice(list, head);
-}
-
-/**
- * list_splice_init - join two lists and reinitialise the emptied list.
- * @list: the new list to add.
- * @head: the place to add it in the first list.
- *
- * The list at @list is reinitialised
- */
-static inline void list_splice_init(struct list_head *list,
-				    struct list_head *head)
-{
-	if (!list_empty(list)) {
-		__list_splice(list, head);
-		INIT_LIST_HEAD(list);
-	}
-}
-
-/**
- * list_entry - get the struct for this entry
- * @ptr:	the &struct list_head pointer.
- * @type:	the type of the struct this is embedded in.
- * @member:	the name of the list_struct within the struct.
- */
-#define list_entry(ptr, type, member) \
-	container_of(ptr, type, member)
-
-/**
- * list_for_each	-	iterate over a list
- * @pos:	the &struct list_head to use as a loop counter.
- * @head:	the head for your list.
- */
-#define list_for_each(pos, head) \
-	for (pos = (head)->next; prefetch(pos->next), pos != (head); \
-		pos->next)
-
-/**
- * __list_for_each	-	iterate over a list
- * @pos:	the &struct list_head to use as a loop counter.
- * @head:	the head for your list.
- *
- * This variant differs from list_for_each() in that it's the
- * simplest possible list iteration code, no prefetching is done.
- * Use this for code that knows the list to be very short (empty
- * or 1 entry) most of the time.
- */
-#define __list_for_each(pos, head) \
-	for (pos = (head)->next; pos != (head); pos = pos->next)
-
-/**
- * list_for_each_prev	-	iterate over a list backwards
- * @pos:	the &struct list_head to use as a loop counter.
- * @head:	the head for your list.
- */
-#define list_for_each_prev(pos, head) \
-	for (pos = (head)->prev; prefetch(pos->prev), pos != (head); \
-		pos = pos->prev)
-
-/**
- * list_for_each_safe	-	iterate over a list safe against removal of list entry
- * @pos:	the &struct list_head to use as a loop counter.
- * @n:		another &struct list_head to use as temporary storage
- * @head:	the head for your list.
- */
-#define list_for_each_safe(pos, n, head) \
-	for (pos = (head)->next, n = pos->next; pos != (head); \
-		pos = n, n = pos->next)
-
-/**
- * list_for_each_entry	-	iterate over list of given type
- * @pos:	the type * to use as a loop counter.
- * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
- */
-#define list_for_each_entry(pos, head, member)				\
-	for (pos = list_entry((head)->next, typeof(*pos), member);	\
-		&pos->member != (head);					\
-		pos = list_entry(pos->member.next, typeof(*pos), member))
-
-/**
- * list_for_each_entry_reverse - iterate backwards over list of given type.
- * @pos:	the type * to use as a loop counter.
- * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
- */
-#define list_for_each_entry_reverse(pos, head, member)			\
-	for (pos = list_entry((head)->prev, typeof(*pos), member);	\
-		prefetch(pos->member.prev), &pos->member != (head);	\
-		pos = list_entry(pos->member.prev, typeof(*pos), member))
-
-/**
- * list_prepare_entry - prepare a pos entry for use as a start point in
- *			list_for_each_entry_continue
- * @pos:	the type * to use as a start point
- * @head:	the head of the list
- * @member:	the name of the list_struct within the struct.
- */
-#define list_prepare_entry(pos, head, member) \
-	((pos) ? : list_entry(head, typeof(*pos), member))
-
-/**
- * list_for_each_entry_continue -	iterate over list of given type
- *			continuing after existing point
- * @pos:	the type * to use as a loop counter.
- * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
- */
-#define list_for_each_entry_continue(pos, head, member)		\
-	for (pos = list_entry(pos->member.next, typeof(*pos), member);	\
-		prefetch(pos->member.next), &pos->member != (head);	\
-		pos = list_entry(pos->member.next, typeof(*pos), member))
-
-/**
- * list_for_each_entry_safe - iterate over list of given type safe against removal of list entry
- * @pos:	the type * to use as a loop counter.
- * @n:		another type * to use as temporary storage
- * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
- */
-#define list_for_each_entry_safe(pos, n, head, member)			\
-	for (pos = list_entry((head)->next, typeof(*pos), member),	\
-		n = list_entry(pos->member.next, typeof(*pos), member);	\
-	     &pos->member != (head);					\
-	     pos = n, n = list_entry(n->member.next, typeof(*n), member))
-
-#endif
-
diff --git a/libmlx5/src/mlx5.c b/libmlx5/src/mlx5.c
index 262a969..058b52f 100644
--- a/libmlx5/src/mlx5.c
+++ b/libmlx5/src/mlx5.c
@@ -730,7 +730,7 @@ static int mlx5_init_context(struct verbs_device *vdev,
 	mlx5_read_env(&vdev->device, context);
 
 	mlx5_spinlock_init(&context->hugetlb_lock);
-	INIT_LIST_HEAD(&context->hugetlb_list);
+	list_head_init(&context->hugetlb_list);
 
 	context->ibv_ctx.ops = mlx5_ctx_ops;
 
diff --git a/libmlx5/src/mlx5.h b/libmlx5/src/mlx5.h
index 80c69a4..6c4e830 100644
--- a/libmlx5/src/mlx5.h
+++ b/libmlx5/src/mlx5.h
@@ -39,7 +39,7 @@
 #include <infiniband/driver.h>
 #include <infiniband/arch.h>
 #include "mlx5-abi.h"
-#include "list.h"
+#include <ccan/list.h>
 #include "bitmap.h"
 #include <ccan/minmax.h>
 
@@ -354,7 +354,7 @@ struct mlx5_hugetlb_mem {
 	int			shmid;
 	void		       *shmaddr;
 	struct mlx5_bitmap	bitmap;
-	struct list_head	list;
+	struct list_node	entry;
 };
 
 struct mlx5_buf {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
