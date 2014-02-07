From: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: RE: RDMA/ocrdma: Add driver for Emulex OneConnect IBoE RDMA adapter
Date: Fri, 7 Feb 2014 11:51:53 +0000
Message-ID: <b326dba2-aae1-4a20-918a-d49ff79a7c48@CMEXHTCAS2.ad.emulex.com>
References: <20140207110728.GA6470@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140207110728.GA6470-mgFCXtclrQlZLf2FXnZxJA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Parav Pandit <Parav.Pandit-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Dan,

Thanks for the note, we will supply this patch to fix this on linux-rdma asap.

-Regards
 Devesh

-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Dan Carpenter
Sent: Friday, February 07, 2014 4:37 PM
To: Parav Pandit
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: re: RDMA/ocrdma: Add driver for Emulex OneConnect IBoE RDMA adapter

Hello Parav Pandit,

The patch fe2caefcdf58: "RDMA/ocrdma: Add driver for Emulex OneConnect IBoE RDMA adapter" from Mar 21, 2012, leads to the following static checker warning:

	drivers/infiniband/hw/ocrdma/ocrdma_verbs.c:1419 ocrdma_query_qp()
	warn: right shifting to zero

drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
  1414          qp_attr->ah_attr.grh.sgid_index = qp->sgid_idx;
  1415          qp_attr->ah_attr.grh.hop_limit = (params.hop_lmt_rq_psn &
  1416                                            OCRDMA_QP_PARAMS_HOP_LMT_MASK) >>
  1417                                                  OCRDMA_QP_PARAMS_HOP_LMT_SHIFT;
  1418          qp_attr->ah_attr.grh.traffic_class = (params.tclass_sq_psn &
  1419                                                OCRDMA_QP_PARAMS_SQ_PSN_MASK) >>
  1420                                                  OCRDMA_QP_PARAMS_TCLASS_SHIFT;
                                                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ We always set traffic_class to zero.  Maybe OCRDMA_QP_PARAMS_TCLASS_MASK was intended instead of OCRDMA_QP_PARAMS_SQ_PSN_MASK?

Btw, the reason we are seing this bug is because the names are horrible.
Try reading the variable names out loud.  OCRDMA_QP_PARAMS_SQ_PSN_MASK is 6 words.  It's 16 syllables long.  It takes me about 4 seconds to just pronounce it.  The next one is almost identical except for one or two characters in the middle.  http://www.spotthedifference.com

Even though the variable names are longer than a Tolstoy novel, I still have no idea what they mean.  I know that the "T" in OCRDMA_QP_PARAMS_TCLASS_SHIFT stands for "traffic" but when it comes to the "SQ_PSN" then I have no idea about that.

  1421  
  1422          qp_attr->ah_attr.ah_flags = IB_AH_GRH;

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
