From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: Re: [infiniband-hw-i40iw] question about identical code for
 different branches
Date: Thu, 18 May 2017 12:54:13 -0500
Message-ID: <20170518125413.Horde.xnD_6K5mFzkhQLdyz7R3LXt@gator4166.hostgator.com>
References: <20170517170654.Horde.cfktFjC4G4wPJvJ8X1ZyUvW@gator4166.hostgator.com>
 <9DD61F30A802C4429A01CA4200E302A730338947@fmsmsx116.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9DD61F30A802C4429A01CA4200E302A730338947@fmsmsx116.amr.corp.intel.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc: "Latif, Faisal" <faisal.latif@intel.com>, Doug Ledford <dledford@redhat.com>, "Hefty, Sean" <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


Quoting "Saleem, Shiraz" <shiraz.saleem@intel.com>:

>> Subject: [infiniband-hw-i40iw] question about identical code for  
>> different branches
>>
>>
>> index f4d1368..48fd327 100644
>> --- a/drivers/infiniband/hw/i40iw/i40iw_virtchnl.c
>> +++ b/drivers/infiniband/hw/i40iw/i40iw_virtchnl.c
>> @@ -443,10 +443,7 @@ enum i40iw_status_code i40iw_vchnl_recv_pf(struct
>> i40iw_sc_dev *dev,
>>          if (!dev->vchnl_up)
>>                  return I40IW_ERR_NOT_READY;
>>          if (vchnl_msg->iw_op_code == I40IW_VCHNL_OP_GET_VER) {
>> -               if (vchnl_msg->iw_op_ver != I40IW_VCHNL_OP_GET_VER_V0)
>> -                       vchnl_pf_send_get_ver_resp(dev, vf_id, vchnl_msg);
>> -               else
>> -                       vchnl_pf_send_get_ver_resp(dev, vf_id, vchnl_msg);
>> +               vchnl_pf_send_get_ver_resp(dev, vf_id, vchnl_msg);
>>                  return I40IW_SUCCESS;
>>          }
>>          for (iw_vf_idx = 0; iw_vf_idx < I40IW_MAX_PE_ENABLED_VF_COUNT;
>> iw_vf_idx++) {
>>
>> What do you think?
>>
>> I'd really appreciate any comment on this.
>>
> Yes. This fix is fine.
>

I'll send a patch in a full and proper format shortly.

Thank you all for your comments.
--
Gustavo A. R. Silva
