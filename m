From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 3.2] IB/qib: Change lkey table allocation to support more
 MRs
Date: Tue, 6 Oct 2015 08:58:05 +0300
Message-ID: <561362ED.9000105@mellanox.com>
References: <20150929145143.27497.86046.stgit@phlsvslse11.ph.intel.com>
 <560B933D.7020605@mellanox.com>
 <32E1700B9017364D9B60AED9960492BC257D8BB0@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <32E1700B9017364D9B60AED9960492BC257D8BB0-RjuIdWtd+YbTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 02/10/2015 16:10, Marciniszyn, Mike wrote:
>>> The lkey table is allocated with with a get_user_pages() with an
>> Don't you mean __get_free_pages?
>>
>=20
> I was a nit in the original upstream commit.
>=20
> I don=E2=80=99t think it is a big deal since the patch context clarif=
ies.
I agree it's not a big deal. I guess it only caught my attention since
reading it made me wonder why you need pinned user memory for the lkey
table.

Haggai
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
