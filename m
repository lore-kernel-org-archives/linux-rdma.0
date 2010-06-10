From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: Re: [PATCH v2 10/15] opensm: Add opensm option to specify file
 name for extra torus-2QoS configuration information.
Date: Thu, 10 Jun 2010 08:22:33 -0600
Message-ID: <1276179753.4570.19.camel@sale659.sandia.gov>
References: <1268244416-20351-1-git-send-email-jaschut@sandia.gov>
 <1268244416-20351-10-git-send-email-jaschut@sandia.gov>
 <20100610112519.GO20172@me>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100610112519.GO20172@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "eitan-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <eitan-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Hi Sasha,

Thanks for taking a look at this.


On Thu, 2010-06-10 at 05:25 -0600, Sasha Khapyorsky wrote:
> Hi Jim,
> 
> On 11:06 Wed 10 Mar     , Jim Schutt wrote:
> > 
> > Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
> > ---
> >  opensm/include/opensm/osm_base.h   |   18 ++++++++++++++++++
> >  opensm/include/opensm/osm_subnet.h |    5 +++++
> >  opensm/opensm/main.c               |    9 +++++++++
> >  opensm/opensm/osm_subnet.c         |    1 +
> >  opensm/opensm/osm_torus.c          |    2 +-
> 
> It breaks to apply at this point. It is because file
> 'opensm/opensm/osm_torus.c' doesn't exist in previous patches. Could
> you
> please resend the patch series with files included? Thanks.

So 7/15 has the patch that adds osm_torus.c as a compressed attachment,
because the patch is so big.

I sent it that way because I was afraid it would otherwise be
rejected by vger.

So you want me to resend with that big patch inline?

Also, I have accumulated a few bug fixes to torus-2QoS
that I haven't posted yet.  I can

1) repost the patch series with no attachments, and
   add the bugfix patches at the end of series
2) repost a v3 patchset with these fixes merged.
3) do something else that you prefer.

Let me know?

-- Jim

> 
> Sasha
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
