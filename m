From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 1/2] rdma/cm: support option to allow manually setting
	IB path
Date: Wed, 21 Oct 2009 18:42:45 -0600
Message-ID: <20091022004245.GV14520@obsidianresearch.com>
References: <F0EFC2D8E6A340D48497497670C5969C@amr.corp.intel.com> <A08104C1CF70400F8BEF492AD49C8491@amr.corp.intel.com> <20091020181458.GD14520@obsidianresearch.com> <46770152ACA04B6C8AA9497C45AC8FD0@amr.corp.intel.com> <20091020191404.GH14520@obsidianresearch.com> <9DFD8E65325F4EE990749EEBE4BC33CA@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9DFD8E65325F4EE990749EEBE4BC33CA-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 21, 2009 at 05:14:59PM -0700, Sean Hefty wrote:
> >Maybe something simple:
> >
> >struct ibv_kern_path_rec2
> >{
> >   u32 flags;
> >   struct ibv_kern_path_rec rec;
> >}
> 
> This is more as an RFC:
> 
> Looking at ib_user_path_rec / ibv_kern_path_rec, we could just make
> use of the existing bits that are available.  We have 2 32-bit
> fields that are only used to record a single bit of data, the gids,
> plus numb_path and preference fields.
> 
> We should be able to determine if a path is forward, reverse, or
> both by looking at the sgid and the reversible bit.  Preference
> (flags) could be used to indicate if a path is primary, alternate,
> or for the CM only.  With the exception of the marking a path for
> the CM, the use of the fields in this manner seems somewhat natural
> to me.

I'm reluctant to override fields like this to save 4 bytes. The
clarity and extensibility of using an additional flags field seems
worth it to me, and the processing code is not complex. I cannot think
of a motivation to save the 4 bytes?

As I said, in many ways I would actually much perfer it if the
structure was:

struct ibv_kern_path_rec2
{
    u32 flags;
    u32 pr[512/8/4];
}

Where 'pr' is simply the 64 bytes of data directly from the MAD. The
kernel already has parsing code for it. As it is with the libibcm
things are kind of insane, first we decode the PR mad into an
ibv_path_rec, then convert that into an ibv_kern_path_rec, which is
unpacked into various other structures anyhow. Ik.

The main advantage of the above is that the resolver function can
directly pass the bytes from the SM into the kernel, so if the spec is
extended the path to flow the extension from the SM to the kernel is
already in place.

It is actually very easy to process 'PR', first do this:
for (unsigned int I = 0; I != 64; I++)
   pr[I] = be_to_cpu32(pr[I]);

Then cast to this structure:

#if __BYTE_ORDER == __LITTLE_ENDIAN
struct SAPathRecord {
    uint32_t rsv0;

    uint32_t rsv1;

    uint32_t DGID[4];

    uint32_t SGID[4];

    uint16_t SLID;
    uint16_t DLID;

    uint32_t hopLimit:8;
    uint32_t flowLabel:20;
    uint32_t rsv2:3;
    uint32_t rawTraffic:1;

    uint16_t PKey;
    uint8_t numbPath:7;
    uint8_t reversible:1;
    uint8_t TClass;

    uint8_t rate:6;
    uint8_t rateSelector:2;
    uint8_t MTU:6;
    uint8_t MTUSelector:2;
    uint16_t SL:4;
    uint16_t rsv3:12;

    uint16_t rsv4;
    uint8_t preference;
    uint8_t packetLifeTime:6;
    uint8_t packetLifeTimeSelector:2;

    uint32_t rsv5;
};
#else
struct SAPathRecord {
    uint32_t rsv0;

    uint32_t rsv1;

    uint32_t DGID[4];

    uint32_t SGID[4];

    uint16_t DLID;
    uint16_t SLID;

    uint32_t rawTraffic:1;
    uint32_t rsv2:3;
    uint32_t flowLabel:20;
    uint32_t hopLimit:8;

    uint8_t TClass;
    uint8_t reversible:1;
    uint8_t numbPath:7;
    uint16_t PKey;

    uint16_t rsv3:12;
    uint16_t SL:4;
    uint8_t MTUSelector:2;
    uint8_t MTU:6;
    uint8_t rateSelector:2;
    uint8_t rate:6;

    uint8_t packetLifeTimeSelector:2;
    uint8_t packetLifeTime:6;
    uint8_t preference;
    uint16_t rsv4;

    uint32_t rsv5;
};
#endif

Fin. Super simple. The horror that the kernel uses now is silly code
bloatery :)

Pretty much the same technique that is used for the IP/TCP header in
certain places in the kernel.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
