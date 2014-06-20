From: bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org
Subject: [Bug 78441] New: kmem_cache_free() shouldn't be called when the call
 to kmem_cache_alloc() fails.
Date: Fri, 20 Jun 2014 03:17:49 +0000
Message-ID: <bug-78441-11804@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=78441

            Bug ID: 78441
           Summary: kmem_cache_free() shouldn't be called when the call to
                    kmem_cache_alloc() fails.
           Product: Drivers
           Version: 2.5
    Kernel Version: 2.6.39
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Infiniband/RDMA
          Assignee: drivers_infiniband-rdma-ztI5WcYan/vQLgFONoPN62D2FQJk+8+b@public.gmane.org
          Reporter: rucsoftsec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
        Regression: No

in Function transport_generic_get_mem() at
drivers/target/target_core_transport.c:4340, function kmem_cache_free() is
called even when the call to kmem_cache_alloc() failed.So an invalid memory
access may be triggered.
The related code snippets in transport_generic_get_mem() are as following.
transport_generic_get_mem() @@drivers/target/target_core_transport.c:4340
4339 static int
4340 transport_generic_get_mem(struct se_cmd *cmd, u32 length, u32 dma_size)
4341 {
4342         unsigned char *buf;
4343         struct se_mem *se_mem;
     ...
4360                 if (!(T_TASK(cmd)->t_mem_bidi_list)) {
4361                         kfree(T_TASK(cmd)->t_mem_list);
4362                         return -ENOMEM;
4363                 }
4364         }
4365 
4366         while (length) {
4367                 se_mem = kmem_cache_zalloc(se_mem_cache, GFP_KERNEL);
4368                 if (!(se_mem)) {
4369                         printk(KERN_ERR "Unable to allocate struct
se_mem\n");
4370                         goto out;
4371                 }
     ...
4402 
4403         return 0;
4404 out:
4405         if (se_mem)
4406                 __free_pages(se_mem->se_page, 0);
4407         kmem_cache_free(se_mem_cache, se_mem);
4408         return -1;
4409 }

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
