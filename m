From: Roland Dreier <rdreier@cisco.com>
Subject: [ofa-general] Re: [GIT PULL] please pull ummunotify
Date: Thu, 10 Sep 2009 23:03:25 -0700
Message-ID: <adatyzahvbm.fsf@cisco.com>
References: <aday6omhz9d.fsf@cisco.com>
	<20090911145036.DB65.A69D9226@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <general-bounces@lists.openfabrics.org>
In-Reply-To: <20090911145036.DB65.A69D9226@jp.fujitsu.com> (KOSAKI Motohiro's
	message of "Fri, 11 Sep 2009 14:56:13 +0900 (JST)")
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/general>
List-Post: <mailto:general@lists.openfabrics.org>
List-Help: <mailto:general-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=subscribe>
Sender: general-bounces@lists.openfabrics.org
Errors-To: general-bounces@lists.openfabrics.org
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, general@lists.openfabrics.org, akpm@linux-foundation.org, torvalds@linux-foundation.org
List-Id: linux-rdma@vger.kernel.org


 > Can I this version already solved fork() + COW issue? if so, could you
 > please explain what happen at fork. Obviously RDMA point to either parent
 > or child page, not both. but Corrent COW rule is, first touch process
 > get copyed page and other process still own original page. I think it's 
 > unpecected behavior form RDMA.

No, ummunotify doesn't really help that much with fork() + COW.  If a
parent forks and then touches pages that are actively in use for RDMA,
then of course they get COWed and RDMA goes to the wrong memory (from
the point of view of the parent).

ummunotify does deal with the case where a process forks and touches
memory that was used for RDMA but no longer is -- in that case, the MPI
library has a chance to flush its registration cache because it will get
a ummunotify event invalidating the old mapping.

The real purpose of ummunotify is to allow MPI implementations to cache
registrations, even when the MPI library is used with an application
that does funny things for allocation (mmap()/munmap() or brk(), etc).

 - Roland
