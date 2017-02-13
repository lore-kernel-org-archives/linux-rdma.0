From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: v4.10-rc SRP + mlx5 regression
Date: Mon, 13 Feb 2017 21:52:28 +0000
Message-ID: <1487022735.2719.7.camel@sandisk.com>
References: <20170210235611.3243-1-bart.vanassche@sandisk.com>
         <1630482470.30208948.1486955693106.JavaMail.zimbra@redhat.com>
         <1633827327.30531404.1486994093828.JavaMail.zimbra@redhat.com>
         <20170213141724.GQ14015@mtr-leonro.local>
         <225897984.30545262.1486995841880.JavaMail.zimbra@redhat.com>
         <1971987443.30613645.1487002375580.JavaMail.zimbra@redhat.com>
         <21338434.30712464.1487004451595.JavaMail.zimbra@redhat.com>
         <1301607843.30852658.1487021644535.JavaMail.zimbra@redhat.com>
         <898197116.30855343.1487022400065.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <898197116.30855343.1487022400065.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Content-ID: <BAF267F49CCD9440A28358240ABE4B1C-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-02-13 at 16:46 -0500, Laurence Oberman wrote:
> I will have to run through this again and see where the bisect went wrong.

Hello Laurence,

If you would be considering to repeat the bisect, did you know that a bisect
can be sped up by specifying the names of the files and/or directories that
are suspected? An example:

git bisect start */infiniband */net

Bart.--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
