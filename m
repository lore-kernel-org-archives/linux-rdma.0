From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH perftest] Avoid configuring the MRs with 1's
Date: Sun, 5 Mar 2017 15:14:06 +0000
Message-ID: <SN1PR07MB2207687216813D2BDE8EA57DF82D0@SN1PR07MB2207.namprd07.prod.outlook.com>
References: <1488111691-23620-1-git-send-email-Ram.Amrani@cavium.com>
 <HE1PR05MB11618D7789611C3526FBB791B5540@HE1PR05MB1161.eurprd05.prod.outlook.com>
 <AM5PR0501MB2532CD619D600768E58EB1EEA92D0@AM5PR0501MB2532.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AM5PR0501MB2532CD619D600768E58EB1EEA92D0-Z3o2H//EDN6VqDs954T/B8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zohar Ben Aharon <zoharb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>Hi Ram ,=20
>I applied your patch and =A0start to review,
>did you aware that :
>
>       ((char*)ctx->buf[qp_index])[i] =3D 2 + ((char)rand() % 255);
>      =20
>Will put values from 2-257 ?=20
>      =20
>Thanks,
>
>Zohar Ben Aharon

X % 255 yields a number between 0 and 254.
Adding 2 to that we get a number between 2 and 256.
Since this is a char the actual number stored is in the range 2 and 255 or =
0 (for 256).

HOWEVER, there's still a bug in this line.

(char) should be converted to (unsigned char)

Explanation:
Rand returns a number of 0..<some positive value>
That can turn into 0xff when casting to char. This 0xff *remains* 0xff afte=
r the modulo because it is a negative number!
And 0xff+2=3D=3D1 and the bug occurs again.

I should have verified...

Will send you a fix shortly.

Thank,
Ram



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
