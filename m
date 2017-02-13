From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: v4.10-rc SRP + mlx5 regression
Date: Mon, 13 Feb 2017 16:56:43 -0500 (EST)
Message-ID: <593386104.30858726.1487023003569.JavaMail.zimbra@redhat.com>
References: <20170210235611.3243-1-bart.vanassche@sandisk.com> <20170213141724.GQ14015@mtr-leonro.local> <225897984.30545262.1486995841880.JavaMail.zimbra@redhat.com> <1971987443.30613645.1487002375580.JavaMail.zimbra@redhat.com> <21338434.30712464.1487004451595.JavaMail.zimbra@redhat.com> <1301607843.30852658.1487021644535.JavaMail.zimbra@redhat.com> <898197116.30855343.1487022400065.JavaMail.zimbra@redhat.com> <1487022735.2719.7.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1487022735.2719.7.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Bart Van Assche" <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Cc: hch-jcswGhMUV9g@public.gmane.org, maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Sent: Monday, February 13, 2017 4:52:28 PM
> Subject: Re: v4.10-rc SRP + mlx5 regression
> 
> On Mon, 2017-02-13 at 16:46 -0500, Laurence Oberman wrote:
> > I will have to run through this again and see where the bisect went wrong.
> 
> Hello Laurence,
> 
> If you would be considering to repeat the bisect, did you know that a bisect
> can be sped up by specifying the names of the files and/or directories that
> are suspected? An example:
> 
> git bisect start */infiniband */net
> 
> Bart.--
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
Hello Bart

I will try that, I knew it was possible it but had not used it before so wanted to be careful.
Even being careful something went wrong :)
I was very careful and I waited in between tests to give it long enough.
Perhaps I said good when bad or something like that.

I will use your method and by tomorrow I should have this figured out for you.

Thanks
Laurence
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
