From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: iSER + CentOS 5.7 + Xen lockup
Date: Tue, 8 Nov 2011 09:35:53 +0200
Message-ID: <4EB8DBD9.4000008@mellanox.com>
References: <CAEs876g0rRBzZN59ZWZ4AQTauVbip82BYAXVNOzahojODfO3Bg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAEs876g0rRBzZN59ZWZ4AQTauVbip82BYAXVNOzahojODfO3Bg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mohammed Naser <mnaser-0fRLFNSEtVVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/8/2011 3:14 AM, Mohammed Naser wrote:
> Hello everyone, we had this server crash a couple of times because of (what seems to
> me) some iSER problems.  This node runs all the default drivers that ship with CentOS 5.7

You mentioned Xen in your subject line, but later say CentOS 5.7, what
kernel are you using? is that kernel-xen-2.6.18-274.el5.x86_64.rpm or
kernel-2.6.18-274.el5.x86_64.rpm or anything else? can you provide some high
level description for what does it take to get that crash?


Or.

Also, could you run with debug prints open and in case the crash still 
reproduces,
send me the kernel log (in case it becomes big, compressed offlist will 
be fine...
also I guess vger.kernel.org drops attachments anyway)

You should open libiscsi2 and ib_iser logs, use
"echo 1 > /sys/module/libiscsi2/parameters/debug_libiscsi" and
"echo 2 > /sys/module/ib_iser/parameters/debug_level"




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
