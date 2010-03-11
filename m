From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: IPoIB issues
Date: Thu, 11 Mar 2010 08:56:40 +0200
Message-ID: <20100311065640.GB2081@mtldesk030.lab.mtl.com>
References: <a72123c41003021354y7880e74cud26d6010f23f9458@mail.gmail.com>
 <20100303122937.GA1689@mtldesk030.lab.mtl.com>
 <4B97BB1E.7010900@Voltaire.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4B97BB1E.7010900-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Cc: Josh England <jjengla-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 10, 2010 at 05:30:38PM +0200, Moni Shoua wrote:
> Hi Eli
> Although Josh already reported that the patch seems to fix the issue I have a question though.
> 
> "post_send failed" prints were during work in datagram mode. I don't know if Josh verified 
> that but I don't expect that these prints would go away, even with the patch. Am I right?
The patch does not address these failures directly but maybe as a side
effect they would go away too. Maybe Josh can share with us his
experience.

> 
> BTW, what could be the reason for UD QP post_send() failures?
> 

Usually they should not fail unless the WR is malformed or the QP has
all available WR outstanding, which should not happen in IPoIB. I
think printing the return value is in place so in the future we will
have more information in such cases.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
