From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4] IB/uverbs: Fix race between uverbs_close and
 remove_one
Date: Tue, 26 Apr 2016 10:33:37 -0400
Message-ID: <571F7C41.70700@redhat.com>
References: <1457795927-16634-1-git-send-email-devesh.sharma@broadcom.com>
 <20160312204502.GA8346@obsidianresearch.com>
 <CANjDDBiN8X-Efgp6s2wyT1G6fpQZjdreW0pnnBG71E9jjhy-YA@mail.gmail.com>
 <20160314174814.GB5240@obsidianresearch.com>
 <CANjDDBhVH10=0nSr0q4P4imAX6YrFBhE7QEd4ccRe2yUhN0pQQ@mail.gmail.com>
 <20160315203112.GA2786@obsidianresearch.com>
 <CANjDDBj8aZTeAfwxFuyk9r=kdihfxpxDA69-c4uVxkvcAfXViw@mail.gmail.com>
 <20160317161237.GB19501@obsidianresearch.com>
 <CANjDDBhYH7HsUyP8-Ko7G0tnWxYDGYCGgaC4HK0Eod_isvoWAA@mail.gmail.com>
 <20160317164831.GI19501@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="eAVhINUvl12ImeqwGrVEOKR6DdqDTdW13"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160317164831.GI19501-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--eAVhINUvl12ImeqwGrVEOKR6DdqDTdW13
Content-Type: multipart/mixed; boundary="KEpqFuxs8BBwFaSdIJhRJ7jUmpnm3nGtS"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>,
 Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Message-ID: <571F7C41.70700-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4] IB/uverbs: Fix race between uverbs_close and
 remove_one
References: <1457795927-16634-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
 <20160312204502.GA8346-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <CANjDDBiN8X-Efgp6s2wyT1G6fpQZjdreW0pnnBG71E9jjhy-YA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
 <20160314174814.GB5240-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <CANjDDBhVH10=0nSr0q4P4imAX6YrFBhE7QEd4ccRe2yUhN0pQQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
 <20160315203112.GA2786-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <CANjDDBj8aZTeAfwxFuyk9r=kdihfxpxDA69-c4uVxkvcAfXViw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
 <20160317161237.GB19501-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <CANjDDBhYH7HsUyP8-Ko7G0tnWxYDGYCGgaC4HK0Eod_isvoWAA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
 <20160317164831.GI19501-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
In-Reply-To: <20160317164831.GI19501-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

--KEpqFuxs8BBwFaSdIJhRJ7jUmpnm3nGtS
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 3/17/2016 12:48 PM, Jason Gunthorpe wrote:
> On Thu, Mar 17, 2016 at 10:01:55PM +0530, Devesh Sharma wrote:
>> On Thu, Mar 17, 2016 at 9:42 PM, Jason Gunthorpe
>> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>>> On Thu, Mar 17, 2016 at 09:38:30PM +0530, Devesh Sharma wrote:
>>>
>>>> To my mind mutex is *not* solving the problem completely unless we
>>>> make it a coarser grained lock. The possible deadlock problem still
>>>> lingers around it.
>>>
>>> Review the last version I sent, with this statement in mind:
>>
>> I am sorry I lost the track of it, which one you are point..we have
>> been discussion for a quite some time now!
>=20
> Not saying it is perfect, but it should be close:

Jason, this is your patch since you completely tossed Devesh's work and
did your own.  Can you please post a corrected version of this with a
proper changelog and Signed-off-by.  Thanks.

> --- a/drivers/infiniband/core/uverbs_main.c
> +++ b/drivers/infiniband/core/uverbs_main.c
> @@ -953,18 +953,20 @@ static int ib_uverbs_close(struct inode *inode, s=
truct file *filp)
>  {
>  	struct ib_uverbs_file *file =3D filp->private_data;
>  	struct ib_uverbs_device *dev =3D file->device;
> -	struct ib_ucontext *ucontext =3D NULL;
> +
> +	mutex_lock(&file->cleanup_mutex);
> +	if (file->ucontext) {
> +		ib_uverbs_cleanup_ucontext(file, file->ucontext);
> +		file->ucontext =3D NULL;
> +	}
> +	mutex_unlock(&file->cleanup_mutex);
> =20
>  	mutex_lock(&file->device->lists_mutex);
> -	ucontext =3D file->ucontext;
> -	file->ucontext =3D NULL;
>  	if (!file->is_closed) {
>  		list_del(&file->list);
>  		file->is_closed =3D 1;
>  	}
>  	mutex_unlock(&file->device->lists_mutex);
> -	if (ucontext)
> -		ib_uverbs_cleanup_ucontext(file, ucontext);
> =20
>  	if (file->async_file)
>  		kref_put(&file->async_file->ref, ib_uverbs_release_event_file);
> @@ -1177,26 +1179,28 @@ static void ib_uverbs_free_hw_resources(struct =
ib_uverbs_device *uverbs_dev,
> =20
>  	mutex_lock(&uverbs_dev->lists_mutex);
>  	while (!list_empty(&uverbs_dev->uverbs_file_list)) {
> -		struct ib_ucontext *ucontext;
> -
>  		file =3D list_first_entry(&uverbs_dev->uverbs_file_list,
>  					struct ib_uverbs_file, list);
>  		file->is_closed =3D 1;
> -		ucontext =3D file->ucontext;
>  		list_del(&file->list);
> -		file->ucontext =3D NULL;
>  		kref_get(&file->ref);
>  		mutex_unlock(&uverbs_dev->lists_mutex);
> +
>  		/* We must release the mutex before going ahead and calling
>  		 * disassociate_ucontext. disassociate_ucontext might end up
>  		 * indirectly calling uverbs_close, for example due to freeing
>  		 * the resources (e.g mmput).
>  		 */
>  		ib_uverbs_event_handler(&file->event_handler, &event);
> -		if (ucontext) {
> -			ib_dev->disassociate_ucontext(ucontext);
> -			ib_uverbs_cleanup_ucontext(file, ucontext);
> +		mutex_lock(&file->cleanup_mutex);
> +		if (file->ucontext) {
> +			file->ucontext =3D NULL;
> +			mutex_unlock(&file->cleanup_mutex);
> +			ib_dev->disassociate_ucontext(file->ucontext);
> +			ib_uverbs_cleanup_ucontext(file, file->ucontext);
>  		}
> +		else
> +			mutex_unlock(&file->cleanup_mutex);
> =20
>  		mutex_lock(&uverbs_dev->lists_mutex);
>  		kref_put(&file->ref, ib_uverbs_release_file);
>=20



--KEpqFuxs8BBwFaSdIJhRJ7jUmpnm3nGtS--

--eAVhINUvl12ImeqwGrVEOKR6DdqDTdW13
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXH3xBAAoJELgmozMOVy/d7KAP/0jpe6Hn2XkVKbkc8XzCMpYq
XP/lQf0Sol6ihbbisem5Fru2S+7zXsbuYgqFJcW4ey+AUwWKffsYq1GFdBgO0S3V
i3VTkjc8OcobXPhFzsVwwcYBgbFruwjbtt0WTdRouhQB1zUyougnUivI5L+LjfFH
35o/M1t8AKhoYwns3GmRwi3qxsrYVT1tAXdjTrYwaz/iE5LszBrXRs8SJ/8ltjOs
Bltu28Jv40qCwQJbNuX8b71iKFa2SHmPrNVbvNKRwJ/k5L/e8ZIZmhhjxRJ9HNRH
93UPkZixc+5iOtCKlHJ6rFNhArjPyiihYA4uVaPuEVe+86eP+lsTED8NqyDc2WcS
YnnEHRblagjceJW6U7qcyEa41Uwwz9w1w3afqsxtomQefqS5keS8UFf6AM2CXVoh
jpsyWgE0snlN086uhZpp2rQ1xlUvwwwWaYhsYu8goSh1JdfCQyaDLVJH8xHn4/cK
HboxJ5odrmhl6ziBrbN7hKpSSKwgaiyxCoKVYAqIu92n82QWlIBmQYpiBKi8zhec
pQFeuvJuIIZDXFoE23S7Yfdst9WEqwt0pHbVeQ65GwNrN9kx5JpHYdWsQ1/l/nan
KB7se60ZZGWediCQ+vYe7UBCNXCYmd/CMUJaZOYpddJES7WFpY5f9Z2T44wfD1nL
LxlkZMNvuayQ2SFkamDK
=OWQP
-----END PGP SIGNATURE-----

--eAVhINUvl12ImeqwGrVEOKR6DdqDTdW13--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
