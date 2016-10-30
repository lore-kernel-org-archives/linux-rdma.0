From: Nicholas Mc Guire <der.herr@hofr.at>
Subject: RFC if==else in i40iw_virtchnl.
Date: Sun, 30 Oct 2016 12:33:25 +0000
Message-ID: <20161030123325.GA26456@osadl.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Faisal Latif <faisal.latif@intel.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi Faisal !

 your commit 4097351a47c5 ("i40iw: virtual channel handling files")
 adds the following lines in i40iw_vchnl_recv_pf()

+               if (vchnl_msg->iw_op_ver != I40IW_VCHNL_OP_GET_VER_V0)
+                       vchnl_pf_send_get_ver_resp(dev, vf_id, vchnl_msg);
+               else
+                       vchnl_pf_send_get_ver_resp(dev, vf_id, vchnl_msg);
+               return I40IW_SUCCESS;

 as the if==else here this looks buggy - if it is intended it atleast needs
 a comment/explaination but it did not seem to make much sense in this
 form (Note this is the only place where vchnl_pf_send_get_ver_resp() is 
 being called so the intent is not clear from code review and thus no patch 
 can be resonably suggested.

thx!
hofrat
