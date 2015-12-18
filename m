From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [ANNOUNCE] libcxgb4-1.3.6 release
Date: Fri, 18 Dec 2015 14:23:16 -0600
Message-ID: <008001d139d1$eda92b50$c8fb81f0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Cc: indranil-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, 'Ramaraju Yelavarthy' <ramaraju-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, "Veeresh U. Kokatnur" <veereshuk-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, "Pallathu B. Sadik" <psadik-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello,

A new release of libcxgb4, version 1.3.6, is available at:

https://www.openfabrics.org/downloads/cxgb4/libcxgb4-1.3.6.tar.gz

with md5sum:

129b8cd955c6de29258697f98dfbb351  libcxgb4-1.3.6.tar.gz

I also pushed this to:

git://git.openfabrics.org/~swise/libcxgb4

The tag is named v1.3.6.

Change shortlog:

Hariprasad Shenai (1):
      Gracefully handle unknown CQE status errors

Steve Wise (6):
      libcxgb4: remove config/missing
      libcxgb4: update config.sub and config.guess
      libcxgb4: add NULL check for wr->sg_list
      libcxgb4:Eliminate warnings seen with buildall.sh on a 32 bit system.
      libcxgb4: skip TERMINATE CQEs before testing for errors
      Spin release 1.3.6.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
