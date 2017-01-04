From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 09/15] IB/rxe: Add a runtime check in alloc_index()
Date: Wed, 4 Jan 2017 18:38:45 +0000
Message-ID: <1483555108.3101.1.camel@sandisk.com>
References: <1483353316.3592.14.camel@sandisk.com>
         <1483353638.3592.30.camel@sandisk.com>
         <20170104172704.GU12077@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170104172704.GU12077-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Content-ID: <AE033F371F827344917D317F230A6C84-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "andrew.boyer-8PEkshWhKlo@public.gmane.org" <andrew.boyer-8PEkshWhKlo@public.gmane.org>, "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-01-04 at 19:27 +0200, Leon Romanovsky wrote:
> On Mon, Jan 02, 2017 at 10:41:58AM +0000, Bart Van Assche wrote:
> > Since index values equal to or above 'range' can trigger memory
> > corruption, complain if index >=3D range.
>=20
> It looks like severe bug and the proper error folding is needed, if it
> is a real situation.

Code in other functions guarantees that this condition won't be hit. The wa=
rning
I added is intended to catch bugs if that other code would ever be modified=
.

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
