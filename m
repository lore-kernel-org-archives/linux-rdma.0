From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv3] opensm: Reduce heap consumption by multicast routing
	tables (MFTs)
Date: Fri, 16 Oct 2009 09:28:47 -0400
Message-ID: <f0e08f230910160628w2476fc7and7280dd74d6921f9@mail.gmail.com>
References: <20091014213546.GA32163@comcast.net> <20091015204233.GG20210@me>
	 <f0e08f230910151535p4aed8827p29f7887d0161dbf@mail.gmail.com>
	 <20091016122406.GQ20210@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091016122406.GQ20210@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 16, 2009 at 8:24 AM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>=
 wrote:
> On 18:35 Thu 15 Oct =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>> >> @@ -138,6 +122,51 @@ void osm_mcast_tbl_set(IN osm_mcast_tbl_t * =
p_tbl, IN uint16_t mlid_ho,
>> >>
>> >> =C2=A0/**********************************************************=
************
>> >> =C2=A0 **********************************************************=
************/
>> >> +void
>> >> +osm_mcast_tbl_realloc_mask_tbl(IN osm_mcast_tbl_t * p_tbl,
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0IN osm_subn_t * p_subn, IN uintn_t ml=
id_offset)
>> >
>> > I would suggest to simplify the function name to something like
>> > 'osm_mcast_tbl_realloc()' - osm_mcast_tbl API doesn't have any
>> > information about a buffer internal structure.
>> >
>> >
>> >> +{
>> >> + =C2=A0 =C2=A0 size_t mft_size, size;
>> >> + =C2=A0 =C2=A0 uint16_t (*p_mask_tbl)[][IB_MCAST_POSITION_MAX];
>> >> +
>> >> + =C2=A0 =C2=A0 if (mlid_offset < p_tbl->mft_size)
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
>> >> +
>> >> + =C2=A0 =C2=A0 /*
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0The number of bytes needed in the ma=
sk table is:
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0The (maximum bit mask 'position' + 1=
) times the
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0number of bytes in each bit mask tim=
es the
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0number of MLIDs supported by the tab=
le.
>> >> +
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0We must always allocate the array wi=
th the maximum position
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0since it is (and must be) defined th=
at way the table structure
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0in order to create a pointer to a tw=
o dimensional array.
>> >> + =C2=A0 =C2=A0 =C2=A0*/
>> >> + =C2=A0 =C2=A0 mft_size =3D (mlid_offset + IB_MCAST_BLOCK_SIZE) =
/
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IB_MCAS=
T_BLOCK_SIZE * IB_MCAST_BLOCK_SIZE;
>> >> + =C2=A0 =C2=A0 if (mft_size > (p_tbl->max_block + 1) * IB_MCAST_=
BLOCK_SIZE)
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mft_size =3D (p_tbl->=
max_block + 1) * IB_MCAST_BLOCK_SIZE;
>> >
>> > Hmm, wouldn't this:
>> >
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0mft_size =3D (mlid_offset / IB_MCAST_BL=
OCK_SIZE + 1) * IB_MCAST_BLOCK_SIZE;
>> >
>> > do the same as lines above?
>>
>> What about the limit (max_block) check ?
>
> If passed mlid_offset can exceed this then it is likely needed, but I=
'm
> not sure that this is the case - then we are asking for more mlids th=
an
> a subnet is capable to handle and probably it is blocked somewhere
> already (but I didn't check really).

You're right; this check is not needed.

>
>> >> @@ -154,6 +183,8 @@ boolean_t osm_mcast_tbl_is_port(IN const osm_=
mcast_tbl_t * p_tbl,
>> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(mlid_h=
o <=3D p_tbl->max_mlid_ho);
>> >>
>> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mlid_offset =3D =
mlid_ho - IB_LID_MCAST_START_HO;
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (mlid_offset >=3D =
p_tbl->mft_size)
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 return FALSE;
>> >
>> > If you are introducing new field mft_size, I would also suggest to=
 change
>> > the meaning of max_mlid_ho field to be max configured mlid for thi=
s
>> > table and not max capability mlid (which is almost duplicated by
>> > num_entries field).
>>
>> Yes, almost duplicated.
>>
>> > I suppose that this can be done as separate patch.
>> >
>> > Then all such and similar (many below) checks should be performed =
against
>> > this actually configured max mlid and not against table size. As w=
e
>> > discussed already this prevents some bugs for 'max_mlid < table_si=
ze - 1'
>> > case.
>>
>> I'll look at this subsequent to this patch.
>
> I would suggest to make it first (guess that it is possible without
> relation to MFT reallocation), so we will need to change all those
> lines only once.

OK.

-- Hal


> Sasha
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
