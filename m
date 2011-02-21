From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH 0/2] Improved node descriptions
Date: Mon, 21 Feb 2011 12:30:16 -0600
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB4A20B28B12@MNEXMB1.qlogic.org>
References: <20110217213017.25708.95042.stgit@homer>
 <AANLkTim5MrHMVjaNFtHeWBy82dag4XNxdBcjBEW+d1yb@mail.gmail.com>
 <201102190923.12641.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201102190923.12641.jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Todd Rimmer <todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jack,

The way we handle that right now is in the openibd start script.  What we do is this:

ib_set_node_desc()
{
        # Add node description to sysfs
      ibsysdir="/sys/class/infiniband"
      if [ -d ${ibsysdir} ]; then
          declare -i hca_id=1
          for hca in ${ibsysdir}/*
          do
              if [ -e ${hca}/node_desc ]; then
                  logger -i "Set node_desc for $(basename $hca)"
                  echo -n "@ HCA-${hca_id}" >> ${hca}/node_desc
              fi
              let hca_id++
          done
      fi
}

Once the kernel modification is accepted, I plan to submit a patch for the openibd script.

-----Original Message-----
From: Jack Morgenstein [mailto:jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org]
Sent: Saturday, February 19, 2011 2:23 AM
To: Roland Dreier
Cc: Mike Heinz; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Hal Rosenstock
Subject: Re: [PATCH 0/2] Improved node descriptions

On Friday 18 February 2011 01:20, Roland Dreier wrote:
> This looks like a reasonable approach to me, although of course the SM
> has no way of knowing it should update a port's node description if a
> hostname changes.
>
What about the problem of multiple HCA's of the same type on a single host?
Won't all of them get the identical node description?
Mike, can you add something to handle this case?

(See my original feedback:
http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg04413.html
and see Mike's response:
http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg04414.html

Mike, I agree that doing something for the upstream is better than doing
nothing, but I would still like to see the multiple-HCA case handled. I think
this can be done by adding a query to the low-level driver to distinguish between
HCAs).

-Jack


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
