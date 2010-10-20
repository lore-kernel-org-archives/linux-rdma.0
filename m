From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: ib mad definitions
Date: Wed, 20 Oct 2010 11:28:35 -0600
Message-ID: <20101020172835.GL10362@obsidianresearch.com>
References: <AANLkTimc7sgmyTvW_dgXarUvGzHcN3sRJ6TJQGxU5p7G@mail.gmail.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7FB3CDB@orsmsx501.amr.corp.intel.com> <AANLkTimbmQS0pcfF3CdSokPbAtbCZT7KFbWcSSNsYobk@mail.gmail.com> <20101019102244.21cd2b1e.weiny2@llnl.gov> <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7FB404C@orsmsx501.amr.corp.intel.com> <20101019212926.GH10362@obsidianresearch.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25B801F393@orsmsx501.amr.corp.intel.com> <20101019181256.d0a15afe.weiny2@llnl.gov> <20101020032818.GC413@obsidianresearch.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25B801F651@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B801F651-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 20, 2010 at 09:06:54AM -0700, Hefty, Sean wrote:

> This contains both.  A wire structure was added to libibverbs to
> support librdmacm, which doesn't depend on umad.  There are probably
> only a few of structures that make sense as part of ibverbs - path
> record and maybe multicast record.  But, we'd have to get agreement
> that umad should depend on ibverbs, or we'll always have duplicate
> definitions.

Duplication doesn't concern me too much, as long as the structures are
cast compatible it doesn't matter too much, there is nothing in verbs
that uses the type, for instance?

I think umad should depend on ibverbs (and use ibv_context to open the
device, but that is another subject), and I think the *structures*
should not have a ABI dependency on umad - static inlines and
structure definitions. So you can compile against it without a link
time dependency. This would let rdmacm use the structures, just have
to compile libumad first.

> Jason, can you share a portion of the final output looks like for your codegen?

Well, my codegen is tailored to what I've been doing. I would not use
this approach to target C code, you need to use macros instead of
templates, etc, etc. But that doesn't matter too much, you can codegen
whatever you want, be it mad_get_field, or pack/unpack or the
non-bitfield approach in ib_types.h.

I have something in mind for C that is a combination of bitfields and
the 1-byte=1-bit structure map technique. I'd codegen both host-endian
overlays and network endian overlays. There is good reason for both, IMHO.
[This email is so long already, I can outline my thoughts on this
 seperately if you are interested]

What I've done has great properties, it is very difficult to make an
endian error using it, and it has zero overhead on BE machines.

/* [15.2.5.16] Information on paths through the subnet */
struct SAPathRecord {
    enum { attributeID = 0x35 };
    uint32_t rsv0;

    uint32_t rsv1;

    struct HdrIPv6Addr DGID;

    struct HdrIPv6Addr SGID;

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

This is a host-endian bitfield overlay. Two are output, this is the
host == BE version, the host == LE version is re-ordered:

    uint32_t hopLimit:8;
    uint32_t flowLabel:20;
    uint32_t rsv2:3;
    uint32_t rawTraffic:1;

etc. The neat thing about the codegen is that is analyzes the
arrangement to choose an optimal basic type. Ie TClass is not a
bitfield, but hopLimit is because flowLabel spans a 16 bit quantity.
This helps avoid any bit slicing code overheads by letting the
compiler produce short and byte loads whenever possible.

Use is sort of like:

uint32_t madBuf[256/4];
for (int I = 0; I != 64; I++)
   madBuf[I] = ntohl(madBuf[I]);
SAPathRecord *pr = madBuf;
pr.DLID = 1;
pr.SLID = 2;
pr.TClss = 3;
for (int I = 0; I != 64; I++)
   madBuf[I] = htonl(madBuf[I]);

This avoids all ntoh/hton on types <= 32, and completely avoids all
overhead on BE machines (which is important for me). In most of my
code I stick the swap in the packet RX/TX path.

The down side is that byte arrays, 64 bits and GIDs get messed up, but
those are compartively rare. With the network endian overlays those 3
things are OK but lot of stuff like flowlabel is hoplessly messed up
(need a ntoh20bits() function). I think both arrangements are useful..

The codgen uses C++ templates and anonymous unions to fix up some of
the ugly stuff in the spec, like the byte arrays and the different
labels for the MADHeaders in some cases.. These are special cases in
the script.

/* [14.2.1.2] SMP Format - Direct Routed */
struct SMPFormatDirected {
    enum { mgmtClass = 0x81 };
    union {
        struct MADHeader MADHeader;
        struct {
            uint32_t MADHeader1;
            uint16_t D:1;
            uint16_t status:15;
            uint8_t hopPointer;
            uint8_t hopCount;
            uint32_t MADHeader2[4];
        };
    };

    struct IBA64bit MKey;

    uint16_t drSLID;
    uint16_t drDLID;

    uint32_t rsv0[7];

    uint32_t data[16];

    IBABitFieldArray<8,64> initialPath;
    IBABitFieldArray<8,64> returnPath;
};

Or the 3 bit wide arrays in PMPortSamplesCtl (so gross):

/* [16.1.3.2] Port Performance Data Sampling Control */
struct PMPortSamplesCtl {
    enum { attributeID = 0x10 };
    uint8_t opCode;
    uint8_t portSelect;
    uint8_t tick;
    uint8_t rsv0:5;
    uint8_t counterWidth:3;

    union {
        IBABitFieldArray<3,15,CounterMaskTraits> counterMask;
        struct {
            uint32_t rsv1:2;
            uint32_t counterMask0:3;
            uint32_t counterMask1:3;
            uint32_t counterMask2:3;
            uint32_t counterMask3:3;
            uint32_t counterMask4:3;
            uint32_t counterMask5:3;
            uint32_t counterMask6:3;
            uint32_t counterMask7:3;
            uint32_t counterMask8:3;
            uint32_t counterMask9:3;

            uint16_t rsv2:1;
            uint16_t counterMask10:3;
            uint16_t counterMask11:3;
            uint16_t counterMask12:3;
            uint16_t counterMask13:3;
            uint16_t counterMask14:3;
            uint8_t sampleMechanisms;
            uint8_t rsv3:6;
            uint8_t sampleStatus:2;
        };
    };

The counterMask template's operator [] magically inlines the right
code for foo.counterMask[x] - again this is all about reducing the
possibility for coding error through automation.

Last time this was brought up Roland mentioned he thought the codegen
in gcc was poor for bitfields, I saw something recently that seems to
indicate bitfields are similar/better than slicing:

http://lwn.net/Articles/406067/

> Currently, I'd be happy just starting by having things like the mgmt
> classes, methods, attribute IDs, status values, common mad header,
> rmpp header, and sa header listed in a single place.  Eventually, I
> need the CM MADs defined, which aren't available AFAICT.

The main data I lack is constants for things like error codes in
obscure mads and so forth.

You can codegen things like the componetMask constants quiet easially,
etc.

Since the database annotates structure arrangements and attribute IDs
pretty well the codegen also produces an any-mad printer function with
considerable field decoding. This is incredibly useful for
debugging. ie:

   void print(const CMMRA & S, const char *prefix)
   {
      const uint32_t *p = reinterpret_cast < const uint32_t * >(&S);
      printf("%sGMP :  %08x  LCID=%u\n", prefix, *p++, (unsigned int) S.LCID);
      printf("%sGMP :  %08x  RCID=%u\n", prefix, *p++, (unsigned int) S.RCID);
      printf
         ("%sGMP :  %08x  messageMRAed=%u rsv0=%u serviceTimeout=%u rsv1=%u rsv2=%u\n",
          prefix, *p++, (unsigned int) S.messageMRAed, (unsigned int) S.rsv0,
          (unsigned int) S.serviceTimeout, (unsigned int) S.rsv1,
          (unsigned int) S.rsv2);

      for (unsigned int i = 0; i < 1760 / 32; i++)
         printf("%sGMP :  %08x  %11s[%2u]=%u\n", prefix, *p++,
                i == 0 ? "privateData" : "", i, S.privateData[i]);
   }

This code gen is 500 lines of perl for the structs and another 350 for
the printer code.

> ib_types uses a lot of typedefs and #defines, so we may be able to
> use those to provide backwards compatability.

Maybe? I don't know.. To me the most important thing is to have a
uniform conversion of what is in the spec to code, and from there if
API preserving wrappers are possible then great, otherwise.. ?

A big quibble I have with the naming in ibtypes is I think that
network endian constants are a mistake. Very confusing.

As far as Windows goes.. The great thing about codegen is you can
codegen anything :) As long as the Windows compiler behaves
predictably, we can codegen bitfields for it. There are only two
possible ways to lay out bitfields (high bit first or low bit first)
and the ABI specifies it. Linux ELF arm, ia32, ia64, pcc, mips 32/64
at least all use the same layout.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
