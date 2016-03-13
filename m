From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: sg_map failures when tuning SRP via ib_srp module parameters
 for maximum SG entries
Date: Sat, 12 Mar 2016 19:58:25 -0500 (EST)
Message-ID: <2043305499.21615736.1457830705865.JavaMail.zimbra@redhat.com>
References: <1195068688.21605141.1457794577569.JavaMail.zimbra@redhat.com> <56E4B677.6020809@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56E4B677.6020809-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James Hartsock <hartsjc-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Bart

Linux localhost.localdomain 4.4.5 #1 SMP Sat Mar 12 14:37:30 EST 2016 x86_64 x86_64 x86_64 GNU/Linux

Within srpt on the array I have options ib_srpt srp_max_req_size=4148
On the client I also only have options ib_srpt srp_max_req_size=4148

I have not tuned srp_sq_size as I was only aware of

parm:           srp_max_req_size:Maximum size of SRP request messages in bytes. (int)
parm:           srpt_srq_size:Shared receive queue (SRQ) size. (int)
parm:           srpt_service_guid:Using this value for ioc_guid, id_ext, and cm_listen_id instead of using the node_guid of the first HCA.

Please explain what that does and thanks

Laurence Oberman
Principal Software Maintenance Engineer
Red Hat Global Support Services

----- Original Message -----
From: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
To: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "James Hartsock" <hartsjc-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sent: Saturday, March 12, 2016 7:38:15 PM
Subject: Re: sg_map failures when tuning SRP via ib_srp module parameters for maximum SG entries

On 03/12/16 06:56, Laurence Oberman wrote:
> [ 6097.205716] ib_srpt IB send queue full (needed 68)
> [ 6097.233325] ib_srpt srpt_xfer_data[2731] queue full -- ret=-12

Hello Laurence,

Are you familiar with the ib_srpt parameter srp_sq_size, a parameter 
that is configurable through configfs ? Please note that changing this 
parameter only affects new sessions but that it not affects any existing 
sessions.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
