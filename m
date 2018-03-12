From: Yuval Shaia <yuval.shaia@oracle.com>
Subject: Re: [PATCH] IB/rxe: Remove unused variable (char
 *rxe_qp_state_name[])
Date: Mon, 12 Mar 2018 18:51:08 +0200
Message-ID: <20180312165106.GA5986@yuvallap>
References: <1519769278-20094-1-git-send-email-hernan@vanguardiasur.com.ar>
 <1519769819.23791.19.camel@wdc.com>
 <CALfa3vGLja=CvkK-L+9CV9seF9C=jUkBR9p46bWb4oO1vFkgcg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALfa3vGLja=CvkK-L+9CV9seF9C=jUkBR9p46bWb4oO1vFkgcg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?iso-8859-1?Q?Hern=E1n?= Gonzalez <hernan@vanguardiasur.com.ar>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "monis@mellanox.com" <monis@mellanox.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 28, 2018 at 07:58:20PM -0300, Hernán Gonzalez wrote:
> On Tue, Feb 27, 2018 at 7:17 PM, Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> > On Tue, 2018-02-27 at 19:07 -0300, Hernán Gonzalez wrote:
> >> Note: This is compile only tested as I have no access to the hw.
> >
> > Hello Hernán,
> >
> > Are you aware that the only hardware that is needed to test this driver is
> > an Ethernet interface, and that this driver even supports the loopback
> > interface?
> >
> > Bart.
> >
> 
> Hello Bart,
> 
> No, I didn't know, sorry about that. I'll test it as soon as I can.
> Thanks for the response.

Reviewed-by: Yuval Shaia <yuval.shaia@oracle.com>
Tested-by: Yuval Shaia <yuval.shaia@oracle.com>

> 
> Cheers,
> Hernán
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
