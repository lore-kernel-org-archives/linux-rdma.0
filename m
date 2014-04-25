From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] mm: get_user_pages(write,force) refuse to COW in shared
 areas
Date: Fri, 25 Apr 2014 13:07:01 -0700 (PDT)
Message-ID: <alpine.LSU.2.11.1404251254230.6272@eggly.anvils>
References: <alpine.LSU.2.11.1404040120110.6880@eggly.anvils> <20140424133055.GA13269@redhat.com> <alpine.LSU.2.11.1404241518510.4454@eggly.anvils> <20140425190931.GA11323@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20140425190931.GA11323@redhat.com>
Sender: owner-linux-mm@kvack.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>, Roland Dreier <roland@kernel.org>, Konstantin Khlebnikov <koct9i@gmail.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Mauro Carvalho Chehab <m.chehab@samsung.com>, Omar Ramirez Luna <omar.ramirez@copitl.com>, Inki Dae <inki.dae@samsung.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-rdma@vger.kernel.org, linux-media@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, 25 Apr 2014, Oleg Nesterov wrote:
> 
> And I forgot to mention, there is another reason why I would like to
> change uprobes to follow the same convention. I still think it would
> be better to kill __replace_page() and use gup(FOLL_WRITE | FORCE)
> in uprobe_write_opcode().

Oh, please please do!  I assumed there was a good atomicity reason
for doing it that way, but if you can do it with gup() please do so.

I went off into a little rant about __replace_page() in my reply to you;
but then felt that you had approached with an honest enquiry, and didn't
deserve a rant in response, so I deleted it.

And, of course, I'm conscious that I have from start to finish withheld
my involvement from uprobes, and refused to review that __replace_page()
(beyond insisting that it not be put in a common place for sharing with
KSM, because I just couldn't guarantee it for uprobes).  I'm afraid that
it's much like HWPoison to me, a complexity (nastiness?) way beyond what
I have time to support myself.

Hugh

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
