From: Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH V3 4/4] RDMA/isert: Support iWARP transport
Date: Thu, 2 Jul 2015 00:03:52 +0300
Message-ID: <CAJ3xEMhehOBvmFBFNwZEda3Wc3UyyyK8iH6HrYfVbD0=8MUa-A@mail.gmail.com>
References: <20150701162936.6501.45512.stgit@build.ogc.int>
	<20150701163058.6501.39171.stgit@build.ogc.int>
	<CAJ3xEMjWVwbW0sgVsMj3hPLMRZgJ8srMG89gYzUEbvQAHBaUEw@mail.gmail.com>
	<009a01d0b43f$f5fa8640$e1ef92c0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <009a01d0b43f$f5fa8640$e1ef92c0$@opengridcomputing.com>
Sender: target-devel-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: Doug Ledford <dledford@redhat.com>, Roi Dayan <roid@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Mike Marciniszyn <infinipath@intel.com>, target-devel@vger.kernel.org, Eli Cohen <eli@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 1, 2015 at 11:53 PM, Steve Wise <swise@opengridcomputing.com> wrote:
>> From: Or Gerlitz [mailto:gerlitz.or@gmail.com]

> Yes, the MR is a local MR, but it is used for REMOTE access for iWARP, but not IB.  It think the reason is that in iWARP there is no distinction between local and remote keys.  For iwarp you get 1 key called a Steering Tag or STAG that is used both locally and advertised to the peer (if to be used for REMOTE IO).  Further, that STAG is sent to the peer in the RDMA READ REQUEST and the peer iWARP stack uses it to generate READ RESPONSE messages with the advertised STAG as the READ DESTINATION.  And thus these STAGs require REMOTE_WRITE access flags.  In IB, I believe the "key" sent in the READ REQUEST is not the MR lkey or rkey at all, but a one-shot transaction key, valid for that READ operation only, and the local IB stack uses this key to map to the destination MR/lkey when processing 
 the RDMA READ RESPONSE.  This difference in the protocols is what drives the access flag difference.


Since in IB/RoCE the key sent on the wire isn't actually something
that can be used as rkey by the peer, we can safely do the extra
access flags Oring always and not worry which transport is used.


> Regardless, I'm not sure what you propose I do differently?  The code in this patch does OR the needed access flag if the device is iWARP when creating the DMA_MR.

So always OR and don't branch

Or.
