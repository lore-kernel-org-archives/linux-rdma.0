Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2224BC003
	for <linux-rdma@vger.kernel.org>; Fri, 21 Aug 2026 16:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787328579; cv=none; b=isuIgX+BRkwHplU9HVFOanwLiiQGSe+tlSIDZ/PmXWgoe3cLYdwHhim2U2tdafbN4/ipBlVwIByWJrTgWYU7uMJg+ejcm/Ogm9znYT6Kh5RqVRCTtyAXfh2UrfWMGz62iUbg0IO19JsQ5VTPQi+Nx69gB/i4NDR5aUYjGghWcfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787328579; c=relaxed/simple;
	bh=UpDuxlJNu+C9IkOy+Gt+iaLqq6SZXac+CbmQAoxtTrk=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Ax/xES2W5ezjy1tmwENMt5GP63Pvd6UC3ZyOrmHueBguGc3tF+gcMJ5PuPWylq4me+OPZ+3iw4NXsMhxEhbsp8jh5LkpBYEfIxaLdxA5EKVQ4dfYtUfJbOIhCLWtTwW1XpHoA1D24MA0em/9KPTIBeosjfTB2N24chavqLUMQNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BdnDYJgQ; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BdnDYJgQ"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-92f0b5ed131so94879385a.3
        for <linux-rdma@vger.kernel.org>; Fri, 21 Aug 2026 09:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787328576; x=1787933376; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=o7FBvi8r0lJa+XUCKtNl5RFOXcEBtuei0j+nR1rFbw0=;
        b=BdnDYJgQWJymDeNZhYcI7ONBihfvwhwpUtw1L7dVgSPWFz1re4ua/z0yTezAcwGBcZ
         hqlpSo5FHRm9GoAEezsylZ0+XiyL/2Jg1Py6UU2R8kZIED+FaL6xX+A4UpSDosKMx3+5
         ncvZzC2BKPsRr6X2Yk16NeHe4KnJX0vNdHRg1Lxc0UmHTbhW6ddu6Jx+DBExO5hq669x
         qk2Jrakpma/TmnnH6fEZ5ZoOxjr374LIOCix6BVfRC6yaz89Pj51w7PsVViQei3bO91r
         IyeFFfl3h+VC8RHY95xqFJ/5jt2KI89Ld4/d4pfsiXPNHVQv8v9AdXoynfC/Z1eASJc1
         qnJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787328576; x=1787933376;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=o7FBvi8r0lJa+XUCKtNl5RFOXcEBtuei0j+nR1rFbw0=;
        b=o+E/e6L8mTEPTZK3NU7bfNoE0wEc5Qt0TS7QhoCuMdruXjSZutrDb3rgOJjwZadQkR
         hUJyDkDklzqs75BiQZr9N4Gs9qvFAweLk9/8kZJfRAo9ipNt9GRbpbkFvQavvFNcjVKz
         qB6xn4MrOJqlh3OQBdG/ECX46t4B1rglnMv4E1/1T9dGdhKcE2niA/U2xuTH2kdWP3uh
         RCclBrW1qqjAoOX4qvzcdHfuD1lYGFdwM3ElH0fb3PmI0aqj7GBoilewzb4l0DOkNceR
         iNG5MqHLQ7zJCkHSt4obqvShmA+hS2fEtzB0MiBC7i6475q8o6cZmHR8+E+JlOWLqOCL
         T0UQ==
X-Forwarded-Encrypted: i=1; AHgh+RqaqqlnsRAJDnSYxmY5HMNWwimc5kWFWTmZfVd1FPiUVRuzkkZOXNLUJNW+nB9FNtoTpmwVwsv3bTFo@vger.kernel.org
X-Gm-Message-State: AOJu0YxxTprbgYykktS6A4i8UHYVFcKhP+/dKUkhz856h1lauav3bv9E
	1sQsAsbOOCM4dKDalF1f7rtYClH6g2rOOBq0mYt4K6jcLC/0yHHLEs6zPehgBLRh
X-Gm-Gg: AR+sD12QayR9da/0NQ0EauB6icUmPExQcuei+mWQFKFaE26tsC3dbrZ0qvv8TFLKjqS
	/Q+dzuXNWHyHoBXh68ouwPMjHKOGqD7CsGnNqxLBsPay8U3/NUZ87vaiekIQTMeUW9WGClzzxUP
	tU4k2FWTWeiht19BF8Ln3JXhOV6lk4hQT508hSEar5/L0AktzXoLM0UwTFZlT+4Gfz2iJGi8z2R
	TYq0LOb4s5C8sk6zI919Z/jTuHHeZacWWeWkjrRJ3Ndc5fksN7nEDq6YxEPHYeVe6h4J74SHXRg
	Cp00mUSPoq+qTFZ8NHN2WejIn6hl8x4CvbomrXWHqGollciPNPVl+dj7TxJQSn+ACEFHEQGFQ+g
	APnC4ZxM/aB0YsJqpCltcRZz8XTdxSgelaGhihYQ6T4QLGqK5ux0a71yJKIYq23TmN9za02bldL
	dI0m37BT8ChnFY8AarFmrKcJ3O79k2BQV/4wd9HKDNpaSwIsoW8SxOf/ei2LyatCaOx21muvsnN
	r+HUCeTidXnZerhjc2sQhpB8rwuh74=
X-Received: by 2002:a05:620a:a2c8:10b0:930:f129:1a45 with SMTP id af79cd13be357-93739538e74mr518581085a.30.1787328575641;
        Fri, 21 Aug 2026 09:09:35 -0700 (PDT)
Received: from smtpclient.apple ([2600:1016:b125:e2e1:fd95:4b9f:40d4:e99f])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-937205817f1sm626205385a.32.2026.08.21.09.09.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Aug 2026 09:09:35 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH] RDMA/siw: Fix CEP reference race in siw_accept()
From: Shuangpeng <shuangpeng.kernel@gmail.com>
In-Reply-To: <51ecec6f-1a88-44a5-a089-951c757f95f3@linux.dev>
Date: Fri, 21 Aug 2026 12:09:03 -0400
Cc: jgg@ziepe.ca,
 leon@kernel.org,
 linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <BBA21909-6E49-442D-8B59-48C7249ED71C@gmail.com>
References: <20260816061353.4059242-1-shuangpeng.kernel@gmail.com>
 <51ecec6f-1a88-44a5-a089-951c757f95f3@linux.dev>
To: Bernard Metzler <bernard.metzler@linux.dev>
X-Mailer: Apple Mail (2.3864.600.51.1.1)

Hi Bernard,

Thanks for your reply.

After carefully rechecking the code path, I realized that I had
overlooked synchronization mechanisms: the RDMA core serializes
application QP destruction with iw_cm_accept(), while peer-side teardown
is serialized by siw_cep_set_inuse() and siw_cep_set_free().

Therefore, the concurrent QP-destroy path described in this follow-up
patch is not reachable in the current implementation.

Please disregard my follow-up patch. I apologize for the confusion.

Thanks again for pointing this out.

Best regards,
Shuangpeng


> On Aug 21, 2026, at 11:34, Bernard Metzler <bernard.metzler@linux.dev> =
wrote:
>=20
> On 16.08.2026 08:13, Shuangpeng Bai wrote:
>> siw_accept() associates a CEP with the selected QP while holding
>> qp->state_lock. If the transition to RTS fails, the error path =
releases
>> the lock before detaching that association.
>> The cleanup drops the QP association reference before clearing =
qp->cep.
>> A concurrent QP destroy can acquire qp->state_lock in between, =
observe
>> the stale pointer, and drop the same association reference again. =
This
>> can free the CEP before siw_accept() releases its remaining =
reference,
>> causing a use-after-free.
>=20
> Do we have a stack trace for that use-after-free?>
>> Serialize the error-side detachment with qp->state_lock and clear =
qp->cep
>> before dropping the association reference. This ensures that either =
the
>> accept cleanup or QP teardown removes the association, but not both.
>> This is a follow-up to commit a93949718259 ("RDMA/siw: Fix
>> use-after-free in siw_accept()") and addresses a separate race in the
>> same error path.
>> Fixes: 6c52fdc244b5 ("rdma/siw: connection management")
>> Link: =
https://patch.msgid.link/20260801213632.1086548-1-shuangpeng.kernel@gmail.=
com
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
>> ---
>>  drivers/infiniband/sw/siw/siw_cm.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>> diff --git a/drivers/infiniband/sw/siw/siw_cm.c =
b/drivers/infiniband/sw/siw/siw_cm.c
>> index 0245b25e7271..da1b953f3fa3 100644
>> --- a/drivers/infiniband/sw/siw/siw_cm.c
>> +++ b/drivers/infiniband/sw/siw/siw_cm.c
>> @@ -1751,11 +1751,13 @@ int siw_accept(struct iw_cm_id *id, struct =
iw_cm_conn_param *params)
>>   cep->state =3D SIW_EPSTATE_CLOSED;
>>     siw_free_cm_id(cep);
>=20
> What can destroy the QP at this point?
> An appication QP destroy shall be serialized with this
> accept call by the RDMA core.
>=20
> A concurrent connection drop by peer side would affect
> QP state, but is serialized at the cep using
> siw_cep_set_inuse()/_free() I don't see other cases
> which are not serialized...?
>> + down_write(&qp->state_lock);
>=20
>>   if (qp->cep =3D=3D cep) {
>> - siw_cep_put(cep);
>>   qp->cep =3D NULL;
>> + siw_cep_put(cep);
>>   }
>>   cep->qp =3D NULL;
>> + up_write(&qp->state_lock);
>>   siw_qp_put(qp);
>>  free_cep:
>>   siw_cep_set_free_and_put(cep);
>> base-commit: a9394971825933074032794a5feee5211509c774
>=20

