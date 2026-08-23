Received: from mout.web.de (mout.web.de [212.227.15.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20483326928;
	Sun, 23 Aug 2026 09:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787477866; cv=none; b=dxc4SBl7ho0JEqocKI++jlFmOoqcTJzBHO2OSRkRh4NJ8fyhRcPZL/AgA4OdY0X10TN6JJO0uKwZBX5M6nUy2E2OJJnEq7h9d8BeDELVdYTB5ov1Prmth+9a5FQK75DmCwivUZDnPXj5sP8CwPWAGq4pGELKBzzaT8bmIIum8qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787477866; c=relaxed/simple;
	bh=3IhnQ/bsl747LvRg8Z7cHIre3mng4fHEY9Ak4ch9eeU=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=OlheY8Xp8a8WdywSSJL55qOi4ku30A7g3vrqSJkwqymcnmpH+SdjhcNPg+5hWqyf5Q8INNNQXsEPpclhYwaIsdMGtdtiI+A7sLzXo4okHBupHToUFqaygUAhwjk7k/uVpYbH3RzyyBiU6bk9q6USMiZpVicWm3ah++MAs1eGzaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=g3ZsYnv+; arc=none smtp.client-ip=212.227.15.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="g3ZsYnv+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1787477841; x=1788082641; i=markus.elfring@web.de;
	bh=3IhnQ/bsl747LvRg8Z7cHIre3mng4fHEY9Ak4ch9eeU=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=g3ZsYnv+aTvmINkrkzMEQWMivUNZ0+VGpfR3Jwsi6CYTxgELiIU/sJrl5CZ9XC+Y
	 bujSseQbQjleLAw+0nJaJjEqk9VPMjX+H3bpxKgsIXaVkIN+QRhVn9tW1MBwIO8sZ
	 O/aspYQZaA/buOjA42/X+507XkAmU3CSyEIDXmF4PLcn+tSKMSAtjxEvwCp8f6ML6
	 FZJt/Ewt6ty9hlb/FJs5hezLnl7J1Ux2apsmxY9sty1L+1+YhImmbPULRv8KlHOJf
	 EXqo0gDNw4TIB7k4C51iCT5FXo6LsTn3fkWxGpVr4Zgd2px4ntrgA98Jw39za7xi6
	 KRI+29oL7+pX80EGSQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1Movne-1waDp03WQA-00fjkj; Sun, 23
 Aug 2026 11:37:20 +0200
Message-ID: <cfd7450e-0098-42e3-af4f-d5b47e842d23@web.de>
Date: Sun, 23 Aug 2026 11:37:17 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Qi Zhang <marsy12010123@gmail.com>, Chengfeng Ye <nicoyip.dev@gmail.com>,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-s390@vger.kernel.org, "D. Wythe" <alibuda@linux.alibaba.com>,
 Dust Li <dust.li@linux.alibaba.com>, Sidraya Jayagond
 <sidraya@linux.ibm.com>, Mahanta Jambigi <mjambigi@linux.ibm.com>
Cc: stable@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Tony Lu <tonylu@linux.alibaba.com>,
 Wen Gu <guwen@linux.alibaba.com>
References: <20260823071908.93212-1-marsy12010123@gmail.com>
Subject: Re: [PATCH net v2] net/smc: prevent device removal during connection
 setup
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20260823071908.93212-1-marsy12010123@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:k0yzVJfrcz//DNIpGWuLggyaZDcq25UOxNoyIY32hAXPWoU51uw
 OdU2mLCXbcrO7peh9uIKoFK+TJXV64qSHypspOKnVaJe2PT2wP3Lla2FhCkXUN8xlv4oN78
 /N6kq8I5y5wv73YeSWZbBh7OSagvVkNSdWMaaL+7IV1VLKFw81tai66EB74ph+aG0dY0mxP
 G/35uwtRnJPOAqjGidPfg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:rEY4ripo/OY=;mNio5nelMx7lnKbF0xpJzotcGVH
 Uc17DPlOEsGmM7Vkvdsd9uYQd73zNqmIE1Ajbpk5GYMj4QiOG60hVF69p9IFypnfJmUZMWCsx
 lrsKm6kDe9zXtwLkihPi37MTVCiZIRGwTOOYuOXWeArs5C+sLoCxy6/LQ7woP82ptOnIMBNbE
 3i202lP+3+t8qtVD1UwMTaXmIGi+rIS+XVRpQvLTg1PrTPZxjeVQT/eCf2WyKmlqbDrRQWrP2
 k/QWTqKoqUup5h43Jw56ZOaFWsIHeN8f2hYlYNxwsOxD1rnp4yGec35+aqHuaZLqPUDqZMGTV
 rp4idh3qg2FTFRaKZSbyl+uG7ZrK0VXQIaIIG3JL0qpja0eNWOXufbLMZISK5zNVazFYPEJww
 jsJC+m3Xa9wrFDHWfP9Gn9GCnEUsWm0kAuAfExQPxdTui9L6Pk3qYNAdZvZso1k7x1rXbsNgd
 ikHFso4uy7V07mtX0wTavm2ETnQyk2ay3yEI52uaQbah5GFT4wzBjjLd8/l90kFM59S+wvi7H
 Ml+NNdUemcFxbyCkwc22jj1NEUWVFEobLVJfIn7OzUk4C3t7/tWzDfbplWXbE0Q0arGjuQh9N
 bgFiCa/BeitQD5J4rkZiQZ86aR/Hi8QFra0ZQ85NtqTF3Z3iZVlKIckYtDF830/SSZY6TG9aZ
 GrMLPxJGSvJGUqJNiTh0q0DlNopJZOn1Jjy76/8dyhx5aqF5u9xe8ass5BSxQVVxaYsFg6MTx
 6He8T8BjUS9k91T4RfVMYBtrRNIZdNpLIj/4ZQZv0o1eIeoNZMDtmoHUpBHYfNsDSMhr5+Xw7
 IqWq8+/IfkB7daIL+DdHPWl0TloGJ6VCneMD6Sv7fvNzT664upL8y2+c+PQXbd7XErMj09sDg
 unUo1bSm9b4la4w7+VgWfrgGzQBBRRxlFZEpgy3SW7IrTKXIxE7JqY9wR8RGDPUwdZUGIsMk9
 lxaGbjko5aUCFo4sVRuTIwva2B36tBezGnDmdBg4qXUKDxZ4Fuu2PodwX/7uLbu49rWIepIP5
 +PGn8tNMh3HKirKXPvD+IYHuVU26kund1OhBDV1M5qYTSgnqIGtG66omETdnacFGll5j79FFs
 0Tk0cdLXcURQebeGWqpNdL3CMG1xNFgVCgB2ac9Lp8EDAH7HOtgidmnpK0XoZ6jBu/aHZFbmo
 t/C62+/2kGooKj89sljcnXrLjXFTSRqYLwzWNpefVDnRvnnnBNxyZhbxTP/he5uLjR/IKUKa8
 d7xvgHOo9zCNOFjz9f5qd2wPM4Wh3/cbOQIaMVHBCaaeSK32dB0OBqCuMrf7mTdGoy0SaI1XL
 6LhbRVqpPzxlOXwsKCbPkK+AOYzfFqPbu14PpNOSLJy55ms819aa1jH4nl/Kx7UQ6hVF96NMx
 0o/ZmY8iWtPdlWjVAP4N08kVR4ibGveg/BJdqIFFsIguu2zO0I/Jmr1gdkFRLUFn2VJeEKv41
 FHSeeTXn2brhbAgluo3v/udyRDjQMQMTdccTVzQwinYk0uITuO36XzqKcEC3I5/9P1oNICvOe
 gWcsn7+VDnPbj5s3Ywhh7Z6DbgamuOfu2Wk534Aj75tefiIlyMr415Ee80yktlG0xMEXn4LmS
 ZjMoIKMh3rA/Ckzx0E1avRxKLJBTFykd88IS6HD31Xn/Fuy6s3Je7WWEk5iThINVvYj7l/oi/
 TaDzyklSrKOqnjRMLvkm0jA8wPn7llpdVgpckAxAYr0qWE99pXiD4QuIkyNfQ7B6dnmAdJLg1
 bWwSa5y3+xdGb6G0tcWRDQhspyYt+fftZx7SvVTRciXABPzamX8LIzQunTnDUqkhVwIrsUJyu
 sEo6Enr9RfNLeU3N1NcSXEw6V9gIc14kWs9fp5KNxK7bD/dkV1KlujtgRA8gbigsSLb/UvB55
 naG0rrvYRL6iiVdEJsCaW7O2uCnEDCh+mKx7v/sRvzO54EGS7WIsj+6wBm4E6+Qcr3aKJdoUW
 a8xD+hfLiY7Be3XuQGmAozfKZPqa5T5jduMNrQcNfV4c9hGdgtbo8MInH5siZ6sUSCds9vRHl
 oQ2zRK22dKeEOxyfd6n9T7n19iWKqdCLdVcxy4R8JJsuxkscZQBVzGc+S36mcurAWTp9kuNxl
 3hqlCzFiNjKHXa0Ri/QX7XImZAlbWGS/svEbyY8ykjZRN+HT+2XwpKYJs6fIsqpnCRchNOH3H
 7ofrRwiz3Y/s4rarxubYXAy7uQXyqWRuyh3vF+nQ6sPUdhZZhXgCBNOQHzX2FYgHkXrDFGOAZ
 VUxFs9SA6lP2OwSbSwUJloguJgD+saJGQVlobkLyrTq/u2JF966mSZlSN1riXUXHGLv/G9zqm
 pZFY/gOrzwGriG7dV8GHoYKY+OLXtQamLIwpEkYPqboIJppukNyyuanCFTgSVdy2AfvUhgO1g
 wEQDdFmtzwc53s+zftanM79H9qlzD/9htMwA9gvFSMEy5rRCnfDZfShdDuplIGQ6JMZHI+uWS
 AaDuCldnKwvUdGEmvImuujmIm8/JsvICw7XuyY9XF233PMG/johrRLfmyKu6v9qQBNXnrA+9R
 DA6a6n2s0f5xU/Q2UEkZbhiuHhXXpQ0raOJDLJC0zAbXY2RN3sZu4ZjVQnRunBjaDOLPTuxm1
 T62tjgqAKqxA95alc/kehjIFnOSmzMnJBj1WDqZ0FeN0JbAb7lb7/IWTVb4wAwMM8Jye5Wfk1
 96WJpg1SIhYp4fkObPMLSvhvvkzb3oiHgGF91/q+YmkLN5tH+1Gbo78A5SSIikX0fmmkLPwmX
 wYVHDJZE0JCm4rK+HCW9d0MFldnjmsuHbv0R4yqIWdXwoGoX/wTO05amC7+iO7JaXubOWmM94
 NRMJM3155BjK0JvEI08XSiHTcJhT1S8GT0XZySXoKw/64HJF36abZEX5bdEnegsv0Lt30DPeY
 +yYUf4utb5giIJ95Hww1ZmyqPXiE4CAJU/4qw5ZhDMWdU/YlEbasjdSv1yuFJKroW0JzoKVXk
 TqdO57UnIL/qKt5fuEAk6n3pyooMp5EXA3ewXtquHJxzD2JCDcsvoispmPYhHNorzxJMqgB8K
 VuXtLoMQugAinwl6ZgkN8N48x5YikaOWwncGfnVB7xoRPwx/pRBHYAaxgDFsnROOK/3IdCOeI
 sqJFKNMg02XBOPUecOGsWVHR1VYizVZAycVubQdc65ifa56TRdLdUyLpvDYxddDk2i7v+GwVS
 0q1MfO5Xj0dd9UutuxaziaMPd9aZrkwtelFTf26aZLyVtMPJmcxX36AdApSirM0gJidpEIdyp
 5s4WVOwo3uwIsOZUaF9aXunoVDOqu/scoLAFrWdvVX5kPqp4nO2lBWqDXHe9RhFnqB68Z99hd
 yGnZLIlkp8M3EWyevLghI08K8tBls8sxIaqVUrauHkt5c/rFFfJBeNmysiYYgqzvFWKQkQy0r
 1wwLuqugD2cczxfYbrgzfdU2N6irRINL/E995o9Uro4YkRyQZzBTQSCXkL8O9BUpDJZKIAp+A
 xPVe9ZrjATTI1r72NsXXUX24MP8AhIvlQWCDCRiBihE2YtF1ulDqpo1T1WqYiAp5CAV8gKEBG
 X0ef4slnfSbsWg3OmgzCfI3nozQKPV4wWxe1PSxlin3Indw3tzj90textOktij/4aAtalh1+P
 dp8ZTqXjDJRFemkthN+z7+rRVI495sAlSwRxGcbnup+Ij2lcg48tEMv7/zDIvWd2IMlfJ3Vb/
 p4x+/koxvEIMeVQu3ie5znSZa8e9Pi48qgPpxhzdVAUrtQJ6hRF9a6SWoQt5R2AFhtMoFQGc6
 yi3r+QyYZpnYF3yXxW9cFiUwSGSv0NGL1TLLNf0iA1yaGINCrL3T0kudJJToeVykMirf8X34+
 HjW6s5g2lbz6i3uUuYFyYkoaydzoLvcdEpHct6Zr66sS/N3aHAY9vPTgizvqKpmvNpipCaO6L
 2i6SQO/jl/2zk3SEmoc84lCHU4IxJYwIzH9O+ws8OxZIACKpkkClW6x2NBtWCLINVFBW5AVGG
 arCzi+QU5x1BYhLTbbsHBn7KcaXDBr+7/8HNA3HlFWCKHkZIFm7+Iig+SCOOzFmCcgF/Wz6uP
 Bg+LSVm+ez4pxKpioUjwW5slbVZA+RJCll7628GpH29mcrvF8RcU+YIyAogkGMohmemYJqyGy
 b7S8pp91KDC97MX2JJWNLP6/NKhMxfX4bW+WqUCuMI6tutXNvXL9QvarrCWNilTG0qwVRAYHZ
 Pj2/zfvGWFWPNOmVrNCBNapwNhndZgh0T7wWeWEDQ691wjX3QNGHuPWlQ6M6FZ9zAhccWYwRx
 IPtVjtOTwyxGurGjZgYa3YPD9dWn7bdkoOsE7ucRTmX9P3vGx0DFjnjsGOOsWi4QKwJGuGMPl
 +sUTBf/gZcT+A+FFRJKO0dIfA9Dt2w9ZqUFNOZQKhVxSkUcwWVyqpsvxmAr/52wOXO3WE4IFh
 GAoe9tOLWDXjA0G2NKKBkBP0yTtQAQrbUrpiTUoXtNKwprMS0dZx0jx/91LlH/+WGz70fSkyx
 DDL92jpLhdvILOHh3Sj8p+Bjbl9T/twC3uim0X0iYcYOC8ys06nLL0QAPQF0a1g8CTfIWfpMV
 1Vg9HbtBGd1XFFW/vKH4Io9XwMnHO7m6WBiSk9dYwYF0uSDqMIpotRPcoT8v9x5Q9WsUbVpo/
 YPMFI7mxbEu9oYjSds2ywtUSnq4FL2XmTs+Uf5xp4qt/htvAvDh/J29wCnHzmnbqRHFDLKzSR
 qgJsRjDuaw3dQ3gcHOs8S+h5aNBHUeY9kzwBZTcT2h54dMQt9Z9DbDJluOSCqCohl90gWnzf2
 h9K5DmhIOCunkpv0cyeADdMBixnbEgNE/Z/FSlCSnlQZFVt8MCprOqatwsZl10P+pAILGkymh
 25y/g1W/c5fVPAHERL6+y1FYxOew4t+Ktlz403vkhqy4sO2cMHPUlsDSMNVtY4CwxhPN3Bg9F
 8LvBso7LLiuUFjSqmwttI8/Zx20BAqnmZabz7oWioz+nABqjtuENv5HSptsVN4uqnyjBDfk3y
 yOSjCYCkrqbp6xdEaVZRisVeZLieBd0iyxhOBiYbRAC4H8hUUJHawGGJqox/2G8xpuy/ye58k
 el+VzEtSoT+T0w4gO3lG3TR/aaeoOFUXQaPPzdHpbQYjLabCu7zim+99Gwxy9ak26rxouz1Zs
 dXKxWPu5qzuUT3HSZpZM4F8OInBJNEeYSiQPNUz9cAttV88OWfEeeKcE3CgaBZcPoVSGP0IlJ
 aJg7qGsEjPAvgNoyX+5HqS/3tq6szT33132Cl1xcFEGmP0B5w601QytOFq6o0l25dKoYmzZ0c
 iuhKe0ojhsiY+2BCyPqJdk2MaGXd+C2MI3pe0m/J2GxZRX1crY2Ek3AClTMHIEowkSUIRjO6q
 54Myp4SjMVy5l9S96zYbsUuJEV1ztit7krCzuqbyOsX01wflQ3nFbl/J5qYgewoKKRfe+xNMW
 9VD/Q9l/S+oceGXw/c8s4HduRGXywwdBiYLalFEs4cmmxtml1N4bu1zIIE61JBZ9GfW9rNQuP
 b6Oya8K0pz2YK+v66fNJB2mSU+no33W5jlh3Jx86zQiayXPbG2ETveFrNpzkfuG1PlKu5FTy3
 rgWtAmDiNrXluxoqzOK9eWRZXrffDmoVf+0v8EvNQiR8NLPuiCauqm9ormgUFBQivwNVtfJZr
 jH9SP+tI1LChsVsbkFOVgT0+h9cB/yUT38+GCyxbjSQKdsmnZ0i3qu2USCcymLJv9bvuCbfcx
 F82qeJKW9GYr/ZtCzQkFs1oJW2wdd6tK/vzcVT+Nx5VZZvDhgBgX1X1UKFJTkKq3aEQbKpBn7
 riqmgWwWjht8bWliHLHjvdrOFh9GcUzsdsHKDu554io6DR8gYp7Kl5lNWcjfLU9m+F5Q1ud5U
 ABHV4arcrIR/phuRsqLWKPK97DXI0/1k8dNhwlbIayN9x0qoDUMdNNwc0nI+pVsyrZoi4LYda
 GEbpjl1bAW4C/kj/Y3YaGJBs/hx4p8uG2/eK3htjmEwW2OAi/L3flAg0tCejDMgNr41VdbkIS
 ugt2+iUFEgxYuSvaNauyoYECfEzm1AEf4Pd3jyhsbrRfnjZOOUxU8PCyfKuETkdRtKrAiRymq
 OdVEFrSCOv5CVxQ4gsW1dvOQeJA5RnTzIMQL7C86+xOZX+Rpi24un48nMkOc/vwpbvc1bcfjl
 K9ThADmq7w8E7Xn+wzAJ60v6lz1z4icZP0HwicM2PbYpMZsSb7kN7PVJKArFAB8bdpZ7syOyQ
 mCx17utsqTa9CHAJxwQ2hXQXoP7ujWtbA7TXjX9Ch5qvf+NxZqmEByWqCRp1r5UUZKGX21Y95
 nKndogUhBw+KwW2IyBmeHHAaOauLRGRwWz+RR4gDfAmGNtMzCcAJ9I4xPn1uOpER3t3yy2qqi
 uyo6xBVDghqyL25NdSoc2YRjjwUibFRndnmWNt/aWJWUF63Z9oV4sndQD8HbOV4N57OJMzl8L
 uV6mHtoGOlCpVmH82NLYNAF3nXAKebKD7KfCal0YomkhRWvl2CJCpNfyWuik0ZP1oaXZjWOHS
 bF4lUhmqbTJsmFkSWAiKHF3T06s+Un+wWw5OtWIDs7ImRCVwdHGBKePYiM7iKQQ3jga8tkn72
 RB620r/1M8hwwtmkwNSs6IVKaJLsD33EfWGmqszd4B8nx3mv1BP7Msxt7nSL+f+03XkKfsOeq
 C8hLh7/ouZ7QfR7nGlJEkslSWpe778CoLejx8iBEa

=E2=80=A6
> This change is limited to the reported SMCR lifetime race. SMC-D device
> selection has a similar pre-existing borrowed-pointer lifetime issue and
> requires a separate fix.

May lock guards be applied?
https://elixir.bootlin.com/linux/v7.2/source/include/linux/mutex.h#L253

Regards,
Markus
