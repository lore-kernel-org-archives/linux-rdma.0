From: Dong Young Yoon <dyoon-63aXycvo3TyHXe+LvDLADg@public.gmane.org>
Subject: Question on RDMA atomic operations
Date: Wed, 24 Aug 2016 16:42:34 -0400
Message-ID: <DB0C5879-C46D-47BF-98F8-DECE15CC4D08@umich.edu>
Mime-Version: 1.0 (Mac OS X Mail 10.0 \(3220\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

My name is Dong Young and I am a PhD student at the University of =
Michigan.
Recently, we have been working on a research topic related to RDMA and =
had an observation where there is a race condition between RDMA atomic =
operations (e.g., fetch-and-add) and RDMA 1-sided writes.
We would like to verity whether what we observed is actually true (i.e., =
no atomicity guaranteed between RDMA atomic operation and RDMA =
read/write).
Is it really true? I have also contacted other fellow researchers who =
worked on RDMA, but they do not seem to be 100% sure on this matter.
Thank you so much in advance for your help.

Thanks,
Dong Young=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
