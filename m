From: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: Re: [PATCHv10 0/11] IBoE support to Infiniband
Date: Sun, 10 Oct 2010 09:17:38 +0200
Message-ID: <4CB16892.5070708@mellanox.co.il>
References: <20100826141659.GA8795@mtldesk30> <4CADD1C1.90700@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CADD1C1.90700-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Cc: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 (Resending without HTML stuff)

It is from the days that SDP over RoCE wasn't stable.
In addition, when customers had a very long delay before TCP connection established, in the following scenario:

   1. in libsdp.conf, setting mode to 'both' (Try SDP and fallback to TCP)
   2. application tries to open socket to a remote peer connected using 10G ethernet
   3. Remote host don't support RoCE.

It took few seconds till the CMA gave up trying to connect, and SDP connection failed, and TCP connection was established.

We plan to change the default state of this module parameter to enable SDP over RoCE, and to add the option to disable SDP per interface.
Currently a user can only disable SDP on a subnet/port/application.

- Amir


On 10/07/2010 03:57 PM, Or Gerlitz wrote:
> Eli Cohen wrote:
>> We have successfully tested MPI, SDP, RDS, and native Verbs applications over IBoE.
> I came across your ofed commit e5414cccaa13e6dd80d8d6fc3dafe95355facdef "sdp: module parameter 
> to disable SDP over ROCEE" and wasn't sure what's behind it, can you clarify that?
>
> Or.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
