From: Prasanna Vv <prasanna.vv-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: QoS SL=>VL issue in user mode =?UTF-8?B?bGlicmRtYWNt4oCP?=
Date: Fri, 25 Nov 2011 18:57:09 +0530
Message-ID: <4ECF97AD.90904@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi
I configure QoS in user mode  using librdmacm call:
rdma_set_option(cm_id, RDMA_OPTION_ID,RDMA_OPTION_ID_TOS, &tos, sizeof _tos)

After the connection is established, i query ibv_query_qp (and also 
cm_id->route.path_rec->sl) to check SL, which is correct as per the qos 
choice from qos_policy.config settings.

But the data transfer is not happening in correct VL as per SL=>VL.

For example if SL is 3 the data transfer VL should be 3 (based on 
SL2VLmaptable).
Instead data is always transfered on VL:0, irrepective of SL value.

Interestingly, the same thing is working properly in kernel mode when i 
set tos using the call:
  rdma_set_service_type(cm_id, conn->c_tos);
If i use kernel mode rdma cm, SL=>VL is correct, data transfer post send 
takes place on VL based on SL.

Do you have clue why the user mode libibverb is not tranfering on VL 
based on SL.

Thanks,
Prasanna

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
