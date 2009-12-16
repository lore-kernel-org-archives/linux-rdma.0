From: "Robert Pearson" <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: RE: [Announce] rxe dev tree available (soft RDMAoE)
Date: Wed, 16 Dec 2009 16:36:36 -0600
Message-ID: <032b01ca7ea0$3a4be540$aee3afc0$@com>
References: <4B294BDD.3010405@systemfabricworks.com> <20091216213816.GV6188@obsidianresearch.com> <031b01ca7e99$38abf510$aa03df30$@com> <7FFE592E129646A2B0DB5AC99D0261C7@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7FFE592E129646A2B0DB5AC99D0261C7-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, 'frank zago' <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'John Groves' <john-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sean,

Probably someday. We looked at the ipath driver before writing rxe but the
qib driver came out much later and we haven't really spent any time looking
at it. Currently rxe is written to be standalone and doesn't have an obvious
place to split into pieces. Some of the header files could maybe go into
core. (For example rxe_hdr.h and rxe_opcode.[ch] overlap
include/rdma/ib_pack.h).

The hard parts of the driver are the state machines and they are fairly
specific.

Bob

-----Original Message-----
From: Sean Hefty [mailto:sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org] 
Sent: Wednesday, December 16, 2009 4:20 PM
To: 'Robert Pearson'; 'Jason Gunthorpe'; 'frank zago'
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; 'John Groves'
Subject: RE: [Announce] rxe dev tree available (soft RDMAoE)

>Yes, but later. For now it is still being actively developed and is
changing
>a lot. Once it settles down we plan to convert to patches and push up
>stream.

Is there any commonality that can be shared between rxe and the qlogic
driver?



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
