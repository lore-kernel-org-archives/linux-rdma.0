From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: IPoIB issues
Date: Thu, 11 Mar 2010 09:47:31 +0200
Message-ID: <4B98A013.3040103@voltaire.com>
References: <a72123c41003021354y7880e74cud26d6010f23f9458@mail.gmail.com>	<20100303122937.GA1689@mtldesk030.lab.mtl.com>	<4B97BB1E.7010900@Voltaire.COM> <20100311065640.GB2081@mtldesk030.lab.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100311065640.GB2081-8YAHvHwT2UEvbXDkjdHOrw/a8Rv0c6iv@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>, Josh England <jjengla-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Eli Cohen wrote:
> The patch does not address these failures directly but maybe as a side effect they would go away too. 
The patch seems to solve a case of possible "live lock" happening in a 
node which has both CM and datagram neighbors e.g where ipoib have 
called netif_stop etc but there is now room in the QP for more postings 
which could turn into letting the network layer continue to post if the 
CQ would have been polled. Its hard to see how this  relates to the post 
send error print

> I think printing the return value is in place so in the future we will have more information in such cases.
I posted a patch that does this, but I think it missed the 2.6.34 merge 
cycle.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
