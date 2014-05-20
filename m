From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH v3.1] IB/umad: Fix error handling
Date: Tue, 20 May 2014 13:25:50 +0200
Message-ID: <537B3BBE.4040202@acm.org>
References: <53708666.6060209@acm.org> <537086BA.3020807@acm.org> <1399889890.3017.6.camel@localhost.localdomain> <5375F094.30809@acm.org> <5375F0CD.5080809@acm.org> <1400574821-9562-1-git-send-email-ydroneaud@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1400574821-9562-1-git-send-email-ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 05/20/14 10:33, Yann Droneaud wrote:
> Please find a slightly modified version of your patch to simplify
> a bit the error paths (no backward goto's) and to reduces the amount
> of lines touched.
> 
> I wasn't able to explain it clearly enough in the previous patch review,
> so I've made the changes directly in the file and propose the modified
> patch for you to review.
> 
> As it's only suggestion, feel free to integrate the changes in your
> patch or discard them.

Hello Yann,

It seems like our opinions about backward goto's are different :-) I
thought these are common at the end of error handling code in the Linux
kernel. Anyway, what matters to me is that a fix gets upstream, not
which fix. But please do not expect me to spend more time testing a
patch that has been reworked only because of the coding style aspects
mentioned in your e-mail.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
