From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Subject: RE: [PATCH 23/26] ib: Convert qib_get_user_pages() to
 get_user_pages_unlocked()
Date: Fri, 4 Oct 2013 13:44:10 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC211B0135@FMSMSX107.amr.corp.intel.com>
References: <1380724087-13927-1-git-send-email-jack@suse.cz>
 <1380724087-13927-24-git-send-email-jack@suse.cz>
 <32E1700B9017364D9B60AED9960492BC211AEF75@FMSMSX107.amr.corp.intel.com>
 <20131002152811.GC32181@quack.suse.cz>
 <32E1700B9017364D9B60AED9960492BC211AF005@FMSMSX107.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <32E1700B9017364D9B60AED9960492BC211AF005@FMSMSX107.amr.corp.intel.com>
Content-Language: en-US
Sender: owner-linux-mm@kvack.org
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, infinipath <infinipath@intel.com>, Roland Dreier <roland@kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

> The PSM side of the code is a more traditional use of GUP (like direct I/=
O), so
> I think it is a different use case than the locking for IB memory regions=
.

I have resubmitted the two deadlock fixes using get_user_pages_fast() and m=
arked them stable.

See http://marc.info/?l=3Dlinux-rdma&m=3D138089335506355&w=3D2

Mike

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
