From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: RFC: Immediate data support for SRP
Date: Tue, 21 Jul 2015 08:35:46 -0700
Message-ID: <55AE66D2.7050206@sandisk.com>
References: <55A7CCF1.3080201@sandisk.com>
 <55ABCB34.1000506@dev.mellanox.co.il> <55AD8C3A.9070403@sandisk.com>
 <55AE0E30.40404@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55AE0E30.40404-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 07/21/2015 02:17 AM, Sagi Grimberg wrote:
> Also, what is the imm_length? hard-coded? or do you specify that in the
> login request as well? if so, is the target allowed to lower that value
> (i.e. is it negotiable)?

Hello Sagi,

As you probably know SRP initiator and target drivers negotiate the 
MAXIMUM INITIATOR TO TARGET IU LENGTH (MITTIL) and MAXIMUM TARGET TO 
INITIATOR IU LENGTH (MTTIIL) parameters during login. The choice we made 
is that the initiator must only send immediate data if the size of the 
resulting message does not exceed the MITTIL. Since an SRP target driver 
is only allowed to send back a MITTIL value that is larger than or equal 
to what an initiator requested, the maximum immediate data size is 
controlled by the target driver.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
