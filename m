From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH V2 0/3] New RAW_PACKET QP type
Date: Sun, 07 Nov 2010 15:04:20 -0600
Message-ID: <4CD71454.5050608@opengridcomputing.com>
References: <4CD171F0.8020506@voltaire.com>	<CF9C39F99A89134C9CF9C4CCB68B8DDF25B8308783@orsmsx501.amr.corp.intel.com>	<4CD41D5D.9030103@opengridcomputing.com>	<CF9C39F99A89134C9CF9C4CCB68B8DDF25B83D606E@orsmsx501.amr.corp.intel.com>	<4CD420C3.1090803@opengridcomputing.com>	<CF9C39F99A89134C9CF9C4CCB68B8DDF25B83D6128@orsmsx501.amr.corp.intel.com> <4CD42C54.7010609@opengridcomputing.com> <4CD64C1D.6010908@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CD64C1D.6010908-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>, Alex Rosenbaum <Alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/7/2010 1:50 AM, Or Gerlitz wrote:
> Steve Wise wrote:
>> I'm working on similar code for Chelsio that will use these QPs.
> Will the TX flow require going into kernel space or will be fully offloaded?
>

The RX/TX paths are kernel bypass unless the application wants to block 
for IO.

Steve.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
