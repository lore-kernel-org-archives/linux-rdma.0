From: Brice Goglin <Brice.Goglin@inria.fr>
Subject: Re: [GIT PULL] please pull ummunotify
Date: Fri, 11 Sep 2009 08:15:19 +0200
Message-ID: <4AA9EAF7.5010401@inria.fr>
References: <aday6omhz9d.fsf@cisco.com>	<20090911145036.DB65.A69D9226@jp.fujitsu.com> <adatyzahvbm.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753664AbZIKGPm@vger.kernel.org>
In-Reply-To: <adatyzahvbm.fsf@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <rdreier@cisco.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, torvalds@linux-foundation.org, akpm@linux-foundation.org, jsquyres@cisco.com, linux-rdma@vger.kernel.org, general@lists.openfabrics.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Roland Dreier wrote:
>  > Can I this version already solved fork() + COW issue? if so, could you
>  > please explain what happen at fork. Obviously RDMA point to either parent
>  > or child page, not both. but Corrent COW rule is, first touch process
>  > get copyed page and other process still own original page. I think it's 
>  > unpecected behavior form RDMA.
>
> No, ummunotify doesn't really help that much with fork() + COW.  If a
> parent forks and then touches pages that are actively in use for RDMA,
> then of course they get COWed and RDMA goes to the wrong memory (from
> the point of view of the parent).
>   

My understanding of the code is that fork will end-up calling
copy_page_range() on all VMA, and copy_page_range() calls
mmu_notifier_invalidate_range_start() if  is_cow_mapping() is true,
which should be the case here. So you should get some invalidate events
on fork.

Brice
