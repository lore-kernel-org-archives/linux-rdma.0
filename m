From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] librdmacm: Work-around kernel bug returning uid = 0
Date: Tue, 5 Feb 2013 01:17:31 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237357D431C2@ORSMSX101.amr.corp.intel.com>
References: <1359789368-19641-1-git-send-email-sean.hefty@intel.com>
 <510FC134.8010706@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <510FC134.8010706-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I updated the patch based on your feedback and pushed the change into my git tree.

I plan on creating a new release of the librdmacm this quarter that will contain this fix.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
