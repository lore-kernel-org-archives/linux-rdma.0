From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/4] arbitrary sg lists support
Date: Mon, 01 May 2017 14:50:45 -0400
Message-ID: <1493664645.3041.184.camel@redhat.com>
References: <1492098977-5231-1-git-send-email-maxg@mellanox.com>
         <1492101079.5176.9.camel@sandisk.com>
         <c52b5ce7-5346-419d-26f2-0d4d45d20471@grimberg.me>
         <20170423103439.GC14088@mtr-leonro.local>
         <d697d360-99ca-c3ed-08e2-b89cc50a15b0@grimberg.me>
         <20170423121254.GD14088@mtr-leonro.local>
         <a3264968-2d9e-bda5-1f23-74da248cf4d5@grimberg.me>
         <9a9668fa-87a7-e730-27e2-8a2b3e7fbc36@mellanox.com>
         <8ed506ba-ae7b-af27-2d2a-9a434c22353c@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8ed506ba-ae7b-af27-2d2a-9a434c22353c-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, 2017-04-23 at 17:35 +0300, Sagi Grimberg wrote:
> > 
> > I actually answered here:
> > https://www.spinics.net/lists/linux-rdma/msg46412.html
> 
> Did anything progress with the debug?
> 
> > 
> > Sagi,
> > As you mentioned the IO path is different in SRP and iSER so IMO we
> > should start with SRP debugging. NVMf is similar to iSER (and not
> > SRP)
> > and that's why I think we can apply this patchset.
> 
> My concern is that this might be broken due to the fact that we don't
> know what triggers this.
> 
> > 
> > If you want to wait till we debug SRP issue it's fine, but I can't
> > repro
> > it in my lab so it can take longer.
> 
> I'd prefer not to take a non-mandatory feature that is not guaranteed
> to work.

Indeed.  I've left this series on hold (actually, I've removed it from
patchworks).  When we get this straightened, then please resubmit.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
