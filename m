From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: format string mismatch in drivers/iio/industrialio-core.c:206
Date: Mon, 19 May 2014 16:20:14 +0200
Message-ID: <537A131E.8060002@gmx.de>
References: <537A12D8.5020106@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <537A12D8.5020106-Mmb7MZpHnFY@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 05/19/2014 04:19 PM, Toralf F=C3=B6rster wrote:
> Hi,
>=20
> FIWI cppcheck blames this :
>=20
> [drivers/iio/industrialio-core.c:206]: (warning) %i in format string =
(no. 1) requires 'int *' but the argument type is 'unsigned int *'.
> [drivers/iio/industrialio-core.c:206]: (warning) %i in format string =
(no. 2) requires 'int *' but the argument type is 'unsigned int *'.
>=20
>=20
And btw :

[drivers/infiniband/hw/cxgb3/iwch_provider.c:1138]: (warning) %i in for=
mat string (no. 1) requires 'int *' but the argument type is 'unsigned =
int *'.
[drivers/infiniband/hw/cxgb3/iwch_provider.c:1140]: (warning) %i in for=
mat string (no. 1) requires 'int *' but the argument type is 'unsigned =
int *'.
[drivers/infiniband/hw/cxgb3/iwch_provider.c:1142]: (warning) %i in for=
mat string (no. 1) requires 'int *' but the argument type is 'unsigned =
int *'.


--=20
Toralf

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
