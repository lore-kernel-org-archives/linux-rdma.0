From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] cxgb4: fix undefined behavior in mem.c
Date: Thu, 28 Feb 2019 15:33:08 -0800
Message-ID: <1551396788.31902.213.camel@acm.org>
References: <1551393519-96595-1-git-send-email-shaobo@cs.utah.edu>
         <1551394596.31902.209.camel@acm.org>
         <abf425b1-19ba-9cf5-8288-87ac0dbf6ac7@cs.utah.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <abf425b1-19ba-9cf5-8288-87ac0dbf6ac7@cs.utah.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaobo He <shaobo@cs.utah.edu>, linux-rdma@vger.kernel.org
Cc: Steve Wise <swise@chelsio.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2019-02-28 at 16:18 -0700, Shaobo He wrote:
+AD4 I can't afford a pdf version of the C standard. So I looked at the draft version 
+AD4 used in the link I put in the commit message. It says (in 6.2.4:2),
+AD4 
+AD4 +AGAAYABg
+AD4 The lifetime of an object is the portion of program execution during which 
+AD4 storage is guaranteed to be reserved for it. An object exists, has a constant 
+AD4 address, and retains its last-stored value throughout its lifetime. If an object 
+AD4 is referred to outside of its lifetime, the behavior is undefined. The value of 
+AD4 a pointer becomes indeterminate when the object it points to (or just past) 
+AD4 reaches the end of its lifetime.
+AD4 +AGAAYABg
+AD4 I couldn't find the definition of lifetime over a dynamically allocated object 
+AD4 in the draft of C standard. I refer to this link 
+AD4 (https://en.cppreference.com/w/c/language/lifetime) which suggests that the 
+AD4 lifetime of an allocated object ends after the deallocation function is called 
+AD4 upon it.
+AD4 
+AD4 I think maybe the more problematic issue is that the value of a freed pointer is 
+AD4 intermediate.

In another section of the same draft I found the following:

J.2 Undefined behavior +AFs ... +AF0 The value of a pointer that refers to space
deallocated by a call to the free or realloc function is used (7.22.3).

Since the C standard explicitly refers to free() and realloc(), does that
mean that that statement about undefined behavior does not apply to munmap()
(for user space code) nor to kfree() (for kernel code)?

Bart.
