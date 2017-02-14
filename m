From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: v4.10-rc SRP + mlx5 regression
Date: Tue, 14 Feb 2017 16:53:05 +0000
Message-ID: <1487091172.2466.4.camel@sandisk.com>
References: <20170210235611.3243-1-bart.vanassche@sandisk.com>
         <20170213141724.GQ14015@mtr-leonro.local>
         <225897984.30545262.1486995841880.JavaMail.zimbra@redhat.com>
         <1971987443.30613645.1487002375580.JavaMail.zimbra@redhat.com>
         <21338434.30712464.1487004451595.JavaMail.zimbra@redhat.com>
         <1301607843.30852658.1487021644535.JavaMail.zimbra@redhat.com>
         <898197116.30855343.1487022400065.JavaMail.zimbra@redhat.com>
         <1487022735.2719.7.camel@sandisk.com>
         <568916592.30910570.1487038794766.JavaMail.zimbra@redhat.com>
         <20170214063953.GF6989@mtr-leonro.local>
         <bfca98d3-3f74-c370-7455-71e2ebd583e9@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <bfca98d3-3f74-c370-7455-71e2ebd583e9-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Content-ID: <4DCB88BDF600194C92533E4D3A2D6E42-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-02-14 at 12:00 +0200, Max Gurtovoy wrote:
> can you specify the test that repro these failures ?
> have you tried running with CX5 HCA or only CX4 ?
> I think this commit is right and we have issues in other places.

My proposal is to proceed as Laurence proposed - modify the SRP initiator
driver such that it doesn't use gaps registration anymore. However, an
additional change is needed in addition to the patch Laurence proposed,
namely to call blk_queue_virt_boundary() unconditionally. I'm currently
testing this approach against mlx4.

Bart.--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
