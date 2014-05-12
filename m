From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 2/3] IB/umad: Fix error handling
Date: Mon, 12 May 2014 12:32:03 +0200
Message-ID: <5370A323.5000504@acm.org>
References: <53708666.6060209@acm.org> <537086BA.3020807@acm.org> <1399889890.3017.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1399889890.3017.6.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 05/12/14 12:18, Yann Droneaud wrote:
> Le lundi 12 mai 2014 =C3=A0 10:30 +0200, Bart Van Assche a =C3=A9crit=
 :
>>  	port =3D container_of(inode->i_cdev, struct ib_umad_port, cdev);
>>  	kref_get(&port->umad_dev->ref);
>> =20
>>  	mutex_lock(&port->file_mutex);
>> =20
>> -	if (!port->ib_dev) {
>> -		ret =3D -ENXIO;
>> +	if (!port->ib_dev)
>>  		goto out;
>> -	}
>> =20
>> +	ret =3D -ENOMEM;
> especially here: I think it should be moved in the error handling pat=
h:
>
>>  	file =3D kzalloc(sizeof *file, GFP_KERNEL);
>> -	if (!file) {
>> -		kref_put(&port->umad_dev->ref, ib_umad_release_dev);
>> -		ret =3D -ENOMEM;
> keep it here.

Does this mean that you are not aware that setting the return code
before an if-test is a common coding style in the Linux kernel ? See
e.g. kernel/futex.c or kernel/events/core.c for other examples.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
