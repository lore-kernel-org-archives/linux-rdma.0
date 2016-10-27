From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: Re: [PATCH 0/2] mm: unexport __get_user_pages_unlocked()
Date: Thu, 27 Oct 2016 10:54:36 +0100
Message-ID: <20161027095436.GA5230@lucifer>
References: <20161027095141.2569-1-lstoakes@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20161027095141.2569-1-lstoakes@gmail.com>
Sender: owner-linux-mm@kvack.org
To: linux-mm@kvack.org
Cc: Michal Hocko <mhocko@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Jan Kara <jack@suse.cz>, Hugh Dickins <hughd@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@techsingularity.net>, Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 27, 2016 at 10:51:39AM +0100, Lorenzo Stoakes wrote:
> This patch series continues the cleanup of get_user_pages*() functions taking
> advantage of the fact we can now pass gup_flags as we please.

Note that this patch series has an unfortunate trivial dependency on my recent
'fix up get_user_pages* comments' patch which means this series applies against
-mmots but not mainline at this point in time.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
