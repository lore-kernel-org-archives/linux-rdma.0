From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH for kernel v4.6] IB/srpt: Revert "Convert to percpu_ida
 tag allocation"
Date: Sun, 3 Apr 2016 07:26:27 -0700
Message-ID: <57012813.3030202@sandisk.com>
References: <56FDBA63.7010804@sandisk.com> <20160401030322.GH2670@leon.nu>
 <56FDE739.9090801@sandisk.com>
 <1459655763.13184.45.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1459655763.13184.45.camel-XoQW25Eq2zviZyQQd+hFbcojREIfoBdhmpATvIKMPHk@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: "leon-2ukJVAZIZ/Y@public.gmane.org" <leon-2ukJVAZIZ/Y@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 04/02/16 20:56, Nicholas A. Bellinger wrote:
> Also, I don't know why none of your ib_srpt patches ever make it to
> target-devel, but can you please stop trying to push target driver
> changes upstream without first notifying target-devel..?
>
> Beyond that, are you going to send an bug-fix to address this regression
> in v4.6 code..?  If not, I'll add this to the queue and just do it
> myself.

Hello Nic,

Everyone who is interested in Linux and RDMA and also in the ib_srpt 
target driver is already reading the linux-rdma mailing list as far as I 
know. But I can CC target-devel for future ib_srpt patch submissions if 
you prefer this.

The kernel crash introduced by "Convert to percpu_ida tag allocation" 
occurs as soon as the first SCSI command is received by the ib_srpt 
target driver. This means that that patch had not been tested at all. It 
should have been mentioned in the description of that patch that that 
patch was untested. And untested patches should not be sent to Linus.

Regarding when and how to fix this regression: aligning the ib_srpt 
target driver with what other target drivers are doing would introduce 
new code. New code should be introduced during the merge window. Since 
the v4.6 merge window has been closed I propose to send in the revert 
for v4.6-rc<n> and to send in the new version of this patch for the v4.7 
merge window.

Bart.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
