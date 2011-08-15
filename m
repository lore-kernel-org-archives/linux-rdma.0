From: Greg KH <gregkh-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [patch v2 13/37] add rxe_verbs.c
Date: Mon, 15 Aug 2011 09:13:09 -0700
Message-ID: <20110815161309.GA14708@suse.de>
References: <20110724194300.421253331@systemfabricworks.com>
 <20110724201228.761358826@systemfabricworks.com>
 <CAO+b5-pRQXn08aVOPxeQBzrYXAV+3zD+HZdCCmPTTwBCCzY=ag@mail.gmail.com>
 <20110815144503.GA12014@suse.de>
 <CAO+b5-rsofKNdcjCjBdj1fH7i3DpbHhFajhk0QfNK4DE7nj_SQ@mail.gmail.com>
 <20110815150726.GA12490@suse.de>
 <CAO+b5-ocwYv2_A8PfVUh1yp0CFNYasjTJNQ0F6bj-+wT8npavA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAO+b5-ocwYv2_A8PfVUh1yp0CFNYasjTJNQ0F6bj-+wT8npavA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 15, 2011 at 06:02:23PM +0200, Bart Van Assche wrote:
> On Mon, Aug 15, 2011 at 5:07 PM, Greg KH <gregkh-l3A5Bk7waGM@public.gmane.org> wrote:
> > For a device, you HAVE to be creating these attributes before the
> > hotplug event is sent out, and to do that, you need to set the corr=
ect
> > pointer before registering the device. =A0See the documentation for=
 the
> > driver model for how to do this properly.
>=20
> Are you referring to the "groups" member in "struct device" ?

Yes, or the one in the class or bus structure, depending on what you ar=
e
wanting to create.

> The
> source files I have found so far that fill in this member in a struct
> device are: drivers/s390/cio/css.c and drivers/usb/core/endpoint.c.
> But I haven't found anything about that member in the documents under
> Documentation/driver-model. Is it just me who's again missing
> something ?

The docbook comments in include/linux/device.h?

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
