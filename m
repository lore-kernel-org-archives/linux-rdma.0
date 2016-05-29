From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 libibverbs 2/7] Add member functions to poll an
 extended CQ
Date: Sun, 29 May 2016 18:38:41 -0400
Message-ID: <574B6F71.9060808@redhat.com>
References: <1464533475-18949-1-git-send-email-yishaih@mellanox.com>
 <1464533475-18949-3-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7BLeRAmf1BM7OvbxQaghtHSnRj0gB0gsB"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1464533475-18949-3-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7BLeRAmf1BM7OvbxQaghtHSnRj0gB0gsB
Content-Type: multipart/mixed; boundary="gpl4Cnk0Pej9im6DUjbeOStHA9wIgMH7L"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org,
 talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Message-ID: <574B6F71.9060808-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 libibverbs 2/7] Add member functions to poll an
 extended CQ
References: <1464533475-18949-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
 <1464533475-18949-3-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
In-Reply-To: <1464533475-18949-3-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--gpl4Cnk0Pej9im6DUjbeOStHA9wIgMH7L
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 5/29/2016 10:51 AM, Yishai Hadas wrote:
> From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Currently, ibv_poll_cq is one stop shop for polling all the
> completion's attribute. The current implementation has a few
> implications:
> 1. The vendor's completion format is transformed to an agnostic IB
>    format (copying data which might has been used directly).
> 2. Adding new completion attributes means wasting more time in copies.
> 3. Extensible functions require wasting cycles on logic which
>    determines whether a function is known and implemented in the
>    provider.
>=20
> In order to solve these problems, we introduce a new poll_cq mechanism
> for extensible CQs. Polling is done in batches, where every batch
> could contain more than one completion. A batch is started with
> calling to start_poll function. This already fetches a completion
> that the user can now query using the various query functions.
> Advancing to the next completion is done using next_poll.
> After querying all completions (or when the user wants to stop
> fetching completions in the current batch), end_poll is called.
>=20
> As 'wr_id' and 'status' are mostly used, they can be accessed directly
> and there is no function call for.

So I've been busy with kernel stuff, but I don't really like this patch.
 I'm not really enamored with the entire poll_ex API.

First, I don't like the start_poll/poll/end_poll setup.  I would rather
we do something like using refcounting on the WCs.  Maybe something like
returning an array of pointers to WCs where each WC already has a ref
count taken, and when the user is done, they call ibv_release_wc() (or
something like that) on one or more of these WCs, at which point they
are freed and the hardware can do with them as they wish.

Then, I've been thinking about how to get this data to the user, and
again, I don't really like where we are headed.  I was thinking about
changing it so that we create an enum like so:

enum wc_elements {
	WC_WR_ID,
	WC_WR_STATUS,
	etc.
};

Then we define each cq struct to have a new array called offsets:

struct cq {
	unsigned char	offsets[64]; /* One cache line, should be 64byte aligned *=
/
	....
} __align__(64);

When a cq is created by the driver, it is responsible for filling out
the offsets array (can be static if your driver only has one CQE format,
but if it changes with different options, it allows for that).
Essentially, it is a mapping from the enum of WC items to the position
in the hardware's CQE.  Then you define something like this in the verbs
header file:

static inline u8 __ibv_get_wc_u8(struct cq *cq, struct wc *wc, unsigned
char wc_element)
{
	return *(wc + cq->offsets[wc_element]);
}

and one for the other data sizes too, then something like this:

define ibv_get_wc_element(cq, wc, wc_element, data) \
	{ \
		switch(wc_element) { \
			/* All char size elements */ \
			case WC_WR_STATUS: \
				data =3D __ibv_get_wc_u8(cq, wc, wc_element); \

You get the idea.  The compiler will optimize the above down to static
code at each location.  And you could simplify things a bit by having
another static array that keeps the element sizes in it, and then run
the switch on that.

The long and short of this method is that accessing CQE struct elements
becomes essentially a load of a variable offset from the cq->offsets[]
item, which should stay hot in cache, followed by a lea of the cqe
address and the offset.

I would prefer having to have an individual routine to access each elemen=
t.

I would prefer to avoid all the calls if possible.

And I want something that can be optimized away by the compiler as much
as possible.

The above accomplishes that and has the room to support up to 64
different WC struct elements, with a maximum offset of 256 bytes (much
larger than any WC today).

What do people think of this idea?  If no one shoots holes in it, I will
try to code something up this upcoming week (although I can't promise
it, I currently have two sick children at home and that prevents me from
getting much coding done).




--gpl4Cnk0Pej9im6DUjbeOStHA9wIgMH7L--

--7BLeRAmf1BM7OvbxQaghtHSnRj0gB0gsB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXS294AAoJELgmozMOVy/diSUP/129HrLxn9iAvNePdOIS66it
UjSpnS/91QXoTjQ62F7yIRwmP3szi8Pd/Tp0n7jn8a63SlthX04Fnxx1ERIchsi5
rTurhMROXTfhaa+4B2wDhKsAOAVMMwpO7Ez/kDNmkZD6+f4B5YU4jFF6L37bRKmv
h7ekoy44xTG5ibbDXp8U/dBQCEtTpVf/Cl7iWPcUis4P3IWAQNrG7xEDB0AjX2NV
Hyqs6TevqBOhV3I+GVzIuoQR94ABMmNgBO82PibWukyx7U61H66ifhKlHN0QXRVf
HEwg9WaAemBoNfc27ZbiDDS2J5taUbAkgxAi3+0MuV3zpk5MPawceA3YJZElwV/j
qSpIt5fhkooYQ3nBHeh563UB3AsQOuDN5SZbFFf0dc0C35yulrV/64NAWpUp75V4
6CLKZN53tmGz9aNpe0uU8/mltfG1zVE62sDtrXPHvsfX24hUWqXly8Iu6LSOHq5Z
qASWabnLy9m64+AmpHZ76kqy4W//Bu+KFyWBjUO6VlZCQ/2f93CIy6mVDj0R4oxv
HzYK//GX7mkDA2bToxt6Bs2d5BMiOz5TNvohUVcvZ2x+rX9QY2ysP6gX6cEylDNW
7UkzQc/9LGthhQ2T49Y0GKoCZYE+eD0hSKzK0VGyG43eJ3A6ooCuHAoWPRVwlLn2
DcxyW1g2B4bSZOlZ3I4U
=l+hd
-----END PGP SIGNATURE-----

--7BLeRAmf1BM7OvbxQaghtHSnRj0gB0gsB--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
