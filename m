From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH 11/11] IB/srp: Prevent mapping failures
Date: Wed, 27 Apr 2016 00:08:35 +0300
Message-ID: <571FD8D3.1060403@grimberg.me>
References: <571A936F.7040409@sandisk.com> <571A94AF.7000609@sandisk.com>
 <20160424083538.GF7974@leon.nu> <571D6975.2020905@sandisk.com>
 <20160425055433.GG7974@leon.nu> <571DE793.6090705@grimberg.me>
 <20160425155320.GH7974@leon.nu> <571E42D2.70705@sandisk.com>
 <20160426141229.GI7974@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160426141229.GI7974-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>> I can add a WARN_ON_ONCE() statement for max_pages_per_mr == 1. That will
>> make it easy to figure out where to start looking if in the future a HCA
>> driver would be added that causes max_pages_per_mr == 1.

If we're on the imaginary path, you can flat out fail the host creation.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
