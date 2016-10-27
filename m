From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 1/2] mm: add locked parameter to get_user_pages_remote()
Date: Thu, 27 Oct 2016 12:59:04 +0200
Message-ID: <20161027105903.GI6454@dhcp22.suse.cz>
References: <20161027095141.2569-1-lstoakes@gmail.com>
 <20161027095141.2569-2-lstoakes@gmail.com>
 <20161027105527.GG6454@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20161027105527.GG6454@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
To: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>, Jan Kara <jack@suse.cz>, Hugh Dickins <hughd@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@techsingularity.net>, Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu 27-10-16 12:55:27, Michal Hocko wrote:
> On Thu 27-10-16 10:51:40, Lorenzo Stoakes wrote:
> > This patch adds a int *locked parameter to get_user_pages_remote() to allow
> > VM_FAULT_RETRY faulting behaviour similar to get_user_pages_[un]locked().
> > 
> > Taking into account the previous adjustments to get_user_pages*() functions
> > allowing for the passing of gup_flags, we are now in a position where
> > __get_user_pages_unlocked() need only be exported for his ability to allow
> > VM_FAULT_RETRY behaviour, this adjustment allows us to subsequently unexport
> > __get_user_pages_unlocked() as well as allowing for future flexibility in the
> > use of get_user_pages_remote().
> 
> I would also add that this shouldn't introduce any functional change.

Forgot to mention that this also opens doors to change other g_u_p_r
callers to allow FAULT_RETRY logic.

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
