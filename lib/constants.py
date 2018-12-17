# -*- coding: utf-8 -*-
#
# Electrum - lightweight Bitcoin client
# Copyright (C) 2018 The Electrum developers
#
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation files
# (the "Software"), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge,
# publish, distribute, sublicense, and/or sell copies of the Software,
# and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
# BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
# ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os
import json
from sys import maxsize

from .equihash_params import EquihashParams

GIT_REPO_URL = "https://github.com/BTHPOS/electrum"
GIT_ISSUE_URL = GIT_REPO_URL + "/issues"


def read_json(filename, default):
    path = os.path.join(os.path.dirname(__file__), filename)
    try:
        with open(path, 'r') as f:
            r = json.loads(f.read())
    except:
        r = default
    return r


class BithereumBase(object):
    TESTNET = False
    REGTEST = False

    DEFAULT_PORTS = {'t': '50001', 's': '50002'}

    HEADER_SIZE_LEGACY = 141

    HEADERS_URL = None
    CHECKPOINTS = []

    POW_TARGET_SPACING = 10 * 60
    POW_TARGET_TIMESPAN_LEGACY = 14 * 24 * 60 * 60

    DIGI_AVERAGING_WINDOW = 30
    DIGI_MAX_ADJUST_DOWN = 32
    DIGI_MAX_ADJUST_UP = 16

    LWMA_AVERAGING_WINDOW = 45
    LWMA_ADJUST_WEIGHT_LEGACY = 13772
    LWMA_ADJUST_WEIGHT = 13772
    LWMA_MIN_DENOMINATOR_LEGACY = 10
    LWMA_MIN_DENOMINATOR = 10
    LWMA_SOLVETIME_LIMITATION = True

    EQUIHASH_PARAMS = EquihashParams(n=200, k=9, personalization=b'ZcashPoW')
    EQUIHASH_PARAMS_FORK = EquihashParams(n=144, k=5, personalization=b'BethdPoW')

    CHUNK_SIZE = 252


class BithereumMainnet(BithereumBase):
    WIF_PREFIX = 0x80
    ADDRTYPE_P2PKH = 25
    ADDRTYPE_P2SH = 40
    SEGWIT_HRP = "bth"

    HEADERS_URL = "https://headers.bithereum.network/blockchain_headers.gz"
    GENESIS = "000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f"

    DEFAULT_SERVERS = read_json('servers.json', {})
    CHECKPOINTS = read_json('checkpoints.json', [])

    PREMINE_SIZE = 10000
    BTH_HEIGHT = 555555

    LWMA_HEIGHT = 1

    EQUIHASH_FORK_HEIGHT = 555555

    POW_LIMIT = 0x0007ffffffff0000000000000000000000000000000000000000000000000000
    POW_LIMIT_START = 0x0000000fffff0000000000000000000000000000000000000000000000000000
    POW_LIMIT_LEGACY = 0x00000000ffff0000000000000000000000000000000000000000000000000000

    XPRV_HEADERS = {
        'standard': 0x0488ade4,     # xprv
        'p2wpkh-p2sh': 0x049d7878,  # yprv
        'p2wsh-p2sh': 0x0295b005,   # Yprv
        'p2wpkh': 0x04b2430c,       # zprv
        'p2wsh': 0x02aa7a99,        # Zprv
    }

    XPUB_HEADERS = {
        'standard': 0x0488b21e,     # xpub
        'p2wpkh-p2sh': 0x049d7cb2,  # ypub
        'p2wsh-p2sh': 0x0295b43f,   # Ypub
        'p2wpkh': 0x04b24746,       # zpub
        'p2wsh': 0x02aa7ed3,        # Zpub
    }


class BithereumTestnet(BithereumBase):
    TESTNET = True

    WIF_PREFIX = 0xef
    ADDRTYPE_P2PKH = 65
    ADDRTYPE_P2SH = 63
    SEGWIT_HRP = "tbth"

    GENESIS = "00000000e0781ebe24b91eedc293adfea2f557b53ec379e78959de3853e6f9f6"

    DEFAULT_PORTS = {'t': '51001', 's': '51002'}
    DEFAULT_SERVERS = read_json('servers_testnet.json', {})

    PREMINE_SIZE = 1000
    BTH_HEIGHT = 1

    LWMA_HEIGHT = -1
    LWMA_ADJUST_WEIGHT_LEGACY = 13632
    LWMA_ADJUST_WEIGHT = 13772
    LWMA_MIN_DENOMINATOR_LEGACY = 3
    LWMA_MIN_DENOMINATOR = 10
    LWMA_SOLVETIME_LIMITATION = False

    EQUIHASH_FORK_HEIGHT = 1

    POW_LIMIT = 0x0007ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
    POW_LIMIT_START = 0x0007ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
    POW_LIMIT_LEGACY = 0x00000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffff

    XPRV_HEADERS = {
        'standard': 0x04358394,     # tprv
        'p2wpkh-p2sh': 0x044a4e28,  # uprv
        'p2wsh-p2sh': 0x024285b5,   # Uprv
        'p2wpkh': 0x045f18bc,       # vprv
        'p2wsh': 0x02575048,        # Vprv
    }

    XPUB_HEADERS = {
        'standard': 0x043587cf,     # tpub
        'p2wpkh-p2sh': 0x044a5262,  # upub
        'p2wsh-p2sh': 0x024289ef,   # Upub
        'p2wpkh': 0x045f1cf6,       # vpub
        'p2wsh': 0x02575483,        # Vpub
    }


class BithereumRegtest(BithereumBase):
    REGTEST = True

    WIF_PREFIX = 0xef
    ADDRTYPE_P2PKH = 111
    ADDRTYPE_P2SH = 196
    SEGWIT_HRP = "tbth"

    GENESIS = "0f9188f13cb7b2c71f2a335e3a4fc328bf5beb436012afca590b1a11466e2206"

    DEFAULT_SERVERS = read_json('servers_regtest.json', {})

    PREMINE_SIZE = 1000
    BTH_HEIGHT = 375

    LWMA_HEIGHT = -1

    EQUIHASH_FORK_HEIGHT = -1
    EQUIHASH_PARAMS = EquihashParams(n=48, k=5, personalization=b'ZcashPoW')
    EQUIHASH_PARAMS_FORK = EquihashParams(n=96, k=5, personalization=b'BethdPoW')

    POW_LIMIT = 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
    POW_LIMIT_START = 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
    POW_LIMIT_LEGACY = 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff

    XPRV_HEADERS = {
        'standard': 0x04358394,     # tprv
        'p2wpkh-p2sh': 0x044a4e28,  # uprv
        'p2wsh-p2sh': 0x024285b5,   # Uprv
        'p2wpkh': 0x045f18bc,       # vprv
        'p2wsh': 0x02575048,        # Vprv
    }

    XPUB_HEADERS = {
        'standard': 0x043587cf,     # tpub
        'p2wpkh-p2sh': 0x044a5262,  # upub
        'p2wsh-p2sh': 0x024289ef,   # Upub
        'p2wpkh': 0x045f1cf6,       # vpub
        'p2wsh': 0x02575483,        # Vpub
    }


# don't import net directly, import the module instead (so that net is singleton)
net = BithereumMainnet


def set_mainnet():
    global net
    net = BithereumMainnet


def set_testnet():
    global net
    net = BithereumTestnet


def set_regtest():
    global net
    net = BithereumRegtest
