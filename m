From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [patch v2 13/37] add rxe_verbs.c
Date: Mon, 15 Aug 2011 18:02:23 +0200
Message-ID: <CAO+b5-ocwYv2_A8PfVUh1yp0CFNYasjTJNQ0F6bj-+wT8npavA@mail.gmail.com>
References: <20110724194300.421253331@systemfabricworks.com>
 <20110724201228.761358826@systemfabricworks.com> <CAO+b5-pRQXn08aVOPxeQBzrYXAV+3zD+HZdCCmPTTwBCCzY=ag@mail.gmail.com>
 <20110815144503.GA12014@suse.de> <CAO+b5-rsofKNdcjCjBdj1fH7i3DpbHhFajhk0QfNK4DE7nj_SQ@mail.gmail.com>
 <20110815150726.GA12490@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110815150726.GA12490-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-l3A5Bk7waGM@public.gmane.org>
Cc: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 15, 2011 at 5:07 PM, Greg KH <gregkh-l3A5Bk7waGM@public.gmane.org> wrote:
> For a device, you HAVE to be creating these attributes before the
> hotplug event is sent out, and to do that, you need to set the correc=
t
> pointer before registering the device. =A0See the documentation for t=
he
> driver model for how to do this properly.

Are you referring to the "groups" member in "struct device" ? The
source files I have found so far that fill in this member in a struct
device are: drivers/s390/cio/css.c and drivers/usb/core/endpoint.c.
But I haven't found anything about that member in the documents under
Documentation/driver-model. Is it just me who's again missing
something ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
