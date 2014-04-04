From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] mm: get_user_pages(write,force) refuse to COW in shared
 areas
Date: Fri, 4 Apr 2014 07:52:47 -0700 (PDT)
Message-ID: <alpine.LSU.2.11.1404040733490.7442@eggly.anvils>
References: <alpine.LSU.2.11.1404040120110.6880@eggly.anvils> <20140404123242.GA22320@node.dhcp.inet.fi>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20140404123242.GA22320@node.dhcp.inet.fi>
Sender: owner-linux-mm@kvack.org
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Hugh Dickins <hughd@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>, Roland Dreier <roland@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Konstantin Khlebnikov <koct9i@gmail.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Mauro Carvalho Chehab <m.chehab@samsung.com>, Omar Ramirez Luna <omar.ramirez@copitl.com>, Inki Dae <inki.dae@samsung.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-rdma@vger.kernel.org, linux-media@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, 4 Apr 2014, Kirill A. Shutemov wrote:
> 
> There's comment in do_wp_page() which is not true anymore with patch
> applied. It should be fixed.

The * Only catch write-faults on shared writable pages,
    * read-only shared pages can get COWed by
    * get_user_pages(.write=1, .force=1).

Yes, I went back and forth on that: I found it difficult to remove that
comment without also simplifying the VM_WRITE|VM_SHARED test immediately
above it, possibly even looking again at the ordering of those tests.

In the end I decided to leave changing it to when we do the other
little cleanups outside get_user_pages(), after it's become clear
whether the new EFAULT is troublesome or not.  Most of my testing
had been without any change in do_wp_page(), so I left that out.

> 
> Otherwise, looks good to me:
> 
> Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

Thanks,
Hugh

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
