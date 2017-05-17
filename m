From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [infiniband-hw-i40iw] question about identical code for different
 branches
Date: Wed, 17 May 2017 17:06:54 -0500
Message-ID: <20170517170654.Horde.cfktFjC4G4wPJvJ8X1ZyUvW@gator4166.hostgator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Faisal Latif <faisal.latif@intel.com>, Shiraz Saleem <shiraz.saleem@intel.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


Hello everybody,

While looking into Coverity ID 1362263 I ran into the following piece  
of code at drivers/infiniband/hw/i40iw/i40iw_virtchnl.c:445:

445        if (vchnl_msg->iw_op_code == I40IW_VCHNL_OP_GET_VER) {
446                if (vchnl_msg->iw_op_ver != I40IW_VCHNL_OP_GET_VER_V0)
447                        vchnl_pf_send_get_ver_resp(dev, vf_id, vchnl_msg);
448                else
449                        vchnl_pf_send_get_ver_resp(dev, vf_id, vchnl_msg);
450                return I40IW_SUCCESS;
451        }

The issue is that lines of code 447 and 449 are identical for  
different branches.

My question here is if one of the branches should be modified, or the  
entire _if_ statement replaced?

Maybe a patch like the following could be applied:

index f4d1368..48fd327 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_virtchnl.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_virtchnl.c
@@ -443,10 +443,7 @@ enum i40iw_status_code i40iw_vchnl_recv_pf(struct  
i40iw_sc_dev *dev,
         if (!dev->vchnl_up)
                 return I40IW_ERR_NOT_READY;
         if (vchnl_msg->iw_op_code == I40IW_VCHNL_OP_GET_VER) {
-               if (vchnl_msg->iw_op_ver != I40IW_VCHNL_OP_GET_VER_V0)
-                       vchnl_pf_send_get_ver_resp(dev, vf_id, vchnl_msg);
-               else
-                       vchnl_pf_send_get_ver_resp(dev, vf_id, vchnl_msg);
+               vchnl_pf_send_get_ver_resp(dev, vf_id, vchnl_msg);
                 return I40IW_SUCCESS;
         }
         for (iw_vf_idx = 0; iw_vf_idx <  
I40IW_MAX_PE_ENABLED_VF_COUNT; iw_vf_idx++) {

What do you think?

I'd really appreciate any comment on this.

Thank you!
--
Gustavo A. R. Silva
