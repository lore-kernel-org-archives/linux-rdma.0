From: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH, mstflint] Fix compiler warnings about set-but-not-used
 variables
Date: Tue, 16 Aug 2016 18:28:26 -0700
Message-ID: <b391e823-3df3-b61d-5851-d03db3fe9bd8@gmail.com>
References: <5741F4F2.9080007@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5741F4F2.9080007-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adrian Chiris <adrianc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 05/22/16 11:05, Bart Van Assche wrote:
> Recent gcc versions emit a warning if a variable is set but not used.
> Suppress these warnings by removing dummy assignments to unused arguments.
> Additionally, enable the compiler command-line option -Wno-unused-parameter
> and remove the '(void)arg' statements that thereby became superfluous.

(replying to my own e-mail)

Hello Adrian,

Apparently this patch has not yet been applied? Please let me know if I 
should send it to another person.

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
