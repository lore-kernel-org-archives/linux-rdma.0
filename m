From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: sg_map failures when tuning SRP via ib_srp module parameters for
 maximum SG entries
Date: Sat, 12 Mar 2016 17:29:02 -0800
Message-ID: <56E4C25E.7050000@sandisk.com>
References: <1195068688.21605141.1457794577569.JavaMail.zimbra@redhat.com>
 <56E4B677.6020809@sandisk.com>
 <2043305499.21615736.1457830705865.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2043305499.21615736.1457830705865.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James Hartsock <hartsjc-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 03/12/16 16:58, Laurence Oberman wrote:
> Within srpt on the array I have options ib_srpt srp_max_req_size=4148
> On the client I also only have options ib_srpt srp_max_req_size=4148
>
> I have not tuned srp_sq_size as I was only aware of
>
> parm:           srp_max_req_size:Maximum size of SRP request messages in bytes. (int)
> parm:           srpt_srq_size:Shared receive queue (SRQ) size. (int)
> parm:           srpt_service_guid:Using this value for ioc_guid, id_ext, and cm_listen_id instead of using the node_guid of the first HCA.
>
> Please explain what that does.

Hello Laurence,

The srp_sq_size parameter controls the send queue size per RDMA channel. 
The default value of this parameter is 4096. I think this is the 
parameter that has to be increased to avoid hitting "IB send queue full" 
errors.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
