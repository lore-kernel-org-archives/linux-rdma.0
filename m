From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 11/11] IB/srp: Prevent mapping failures
Date: Mon, 9 May 2016 15:55:05 -0700
Message-ID: <57311549.8010900@sandisk.com>
References: <571A936F.7040409@sandisk.com>
 <2102017158.34060891.1462478304470.JavaMail.zimbra@redhat.com>
 <572BA98F.4090109@sandisk.com> <572BAA6F.1060607@sandisk.com>
 <804753248.34153510.1462481756460.JavaMail.zimbra@redhat.com>
 <572BBDC0.5070205@sandisk.com>
 <1133135399.34245490.1462485666601.JavaMail.zimbra@redhat.com>
 <572BCD59.7010701@sandisk.com>
 <169904890.34764265.1462834206901.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <169904890.34764265.1462834206901.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 05/09/2016 03:50 PM, Laurence Oberman wrote:
> Are we looking at a combination of kernel changes and ib_srp changes here to correct this.

Hello Laurence,

I am working on a patch series that will support a max_sector size of 
4MB and that also will prevent mapping failures. I hope to finish and 
repost that patch series this week. I will CC you on that patch series.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
